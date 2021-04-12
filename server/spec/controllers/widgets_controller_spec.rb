require 'rails_helper'
require 'authentication_helper'

describe WidgetsController do
  include AuthenticationHelper

  let(:entries) do
    lambda do |widgets|
      widgets = widgets.is_a?(Array) ? widgets : [widgets]
      widgets.map do |w|
        w.slice(
          "name",
          "quantity",
          "value_in_cents"
        )
      end
    end
  end
  let!(:one_widget_for_logged_in_user) do
    login

    Widget.create(
      {
        :name => "mo-mom",
        :value_in_cents => 176_85,
        :quantity => 12,
        :user => @user
      }
    )
  end
  let!(:someone_elses_widget_id) do
    second_user = User.create(AuthenticationHelper::SECONDARY_USER[:userDetails])
    Widget.create(
      {
        :name => "do-dad",
        :value_in_cents => 123_00,
        :quantity => 5,
        :user => second_user
      }
    ).id
  end

  describe ":index" do
    let(:route) { get :index }

    it_behaves_like "route is protected"

    context "when logged in user has no widgets" do

      before { one_widget_for_logged_in_user.destroy! }

      it "returns an empty array" do
        route

        response_obj = JSON.parse(response.body)
        expect(response_obj).to eq([])
      end
    end

    context "when logged in user has some widgets" do
      let!(:expected_widgets) do
        [
          Widget.create(
            {
              :name => "do-dad",
              :value_in_cents => 123_00,
              :quantity => 5,
              :user => @user
            }
          ),
          one_widget_for_logged_in_user
        ]
      end

      it "returns an array containing those widgets" do
        route

        response_obj = JSON.parse(response.body)

        expect(entries[response_obj]).to match_array(entries[expected_widgets])
      end
    end
  end

  describe ":show" do
    let(:widget_id) { one_widget_for_logged_in_user.id }
    let(:route) { get :show, :params => { :id => widget_id } }

    it_behaves_like "route is protected"

    context "when the id of the widget is valid for the logged in user" do
      it "returns the widget" do
        route

        response_obj = JSON.parse(response.body)

        expect(entries[response_obj]).to match_array(entries[one_widget_for_logged_in_user])
      end
    end

    context "when the id is not valid for the logged in user" do
      let(:widget_id) { someone_elses_widget_id }

      it "does not return the widget" do
        route

        response_obj = JSON.parse(response.body)

        expect(entries[response_obj]).to match_array([])
      end
    end
  end

  describe ":update" do
    let(:widget_id) { one_widget_for_logged_in_user.id }
    let(:route) { put :update, :params => { :id => widget_id, :widget_details => one_widget_for_logged_in_user.slice(:name, :quantity).merge(:value_in_cents => 500) } }

    it_behaves_like "route is protected"

    context "when the id of the widget is valid for the logged in user" do
      it "updates the widget" do
        route

        response_obj = JSON.parse(response.body)

        one_widget_for_logged_in_user.reload
        expect(entries[response_obj]).to match_array(entries[one_widget_for_logged_in_user])
      end
    end

    context "when the id is not valid for the logged in user" do
      let(:widget_id) { someone_elses_widget_id }

      it "does not update the widget" do
        route

        response_obj = OpenStruct.new(JSON.parse(response.body))

        expect(response_obj.message).to eq("unauthorized")
      end
    end
  end

  describe ":create" do
    let(:new_widget_params) do
      {
        :widget_details => {
          :name => "do-dad",
          :value_in_cents => 123_00,
          :quantity => 5,
          :user_id => @user.id
        }
      }
    end
    let(:route) { post :create, :params => new_widget_params }

    it_behaves_like "route is protected"

    it "creates a new Widget for the logged in user" do
      login 
      
      expect do 
        route
  
        expect(Widget.all.first.user.id).to eq(session[:user_id])
      end.to change { Widget.count }.by(1)
    end
  end

  describe ":destroy" do
    let(:widget_id) { one_widget_for_logged_in_user.id }
    let(:route) { delete :destroy, :params => { :id => widget_id } }

    it_behaves_like "route is protected"

    context "widget id belongs to logged in user" do
      it "deletes the widget" do
        expect do
          route

          expect(Widget.where(:id => widget_id).exists?).to eq(false)
        end.to change { Widget.count }.by(-1)
      end
    end

    context "widget id does not belong to logged in user" do
      let(:widget_id) { someone_elses_widget_id }

      it "does not delete the widget" do
        expect do
          route
        end.not_to change { Widget.count }
      end
    end
  end
end