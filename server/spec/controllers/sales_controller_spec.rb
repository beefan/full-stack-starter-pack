require 'rails_helper'
require 'authentication_helper'

describe SalesController do
  include AuthenticationHelper

  describe ":create" do
    let(:route) { post :create, :params => { :sale_details => { :widget_id => widget_id, :quantity => 5 } } }
    let!(:widget_id) do
      login

      Widget.create(
        :name => "do-dad",
        :quantity => 12,
        :value_in_cents => 123_45,
        :user => @user
      ).id
    end

    it_behaves_like "route is protected"

    it "makes a new sale" do
      expect do
        route
        expect(Sale.all.take.widget_id).to eq(widget_id)
      end.to change { Sale.count }.by(1)
    end

    context "when making a sale for a widget that's not yours" do
      let!(:widget_id) do
        login

        second_user = User.create(
          :username => "superfake",
          :email => "notreal",
          :password => "alsofake"
        )
        Widget.create(
          :name => "do-dad",
          :quantity => 20,
          :value_in_cents => 200,
          :user => second_user
        ).id
      end

      it "does not make the sale" do
        expect do 
          route

          response_obj = OpenStruct.new(JSON.parse(response.body))
          expect(response_obj.message).to eq("unauthorized")
        end.not_to change { Sale.count }
      end
    end
  end

  describe ":destroy" do
    let!(:sale_id) do
      login

      widget = Widget.create(
        :name => "do-dad",
        :quantity => 12,
        :value_in_cents => 123_45,
        :user => @user
      )
      Sale.create(
        :widget => widget,
        :quantity => 3
      ).id
    end
    let(:route) { delete :destroy, :params => { :id => sale_id } }

    it_behaves_like "route is protected"
    
    context "when deleting a widget owned by logged in user" do
      it "successfully deletes the sale" do
        expect do
          route
          expect(Sale.where(:id => sale_id).exists?).to eq(false)
        end.to change { Sale.count }.by(-1)
      end
    end

    context "when deleting a widget not owned by logged in user" do
      let(:sale_id) do
        second_user = User.create(
          :username => "fake",
          :email => "faker@fake.com",
          :password => "fake01!!"
        ) 
        widget = Widget.create(
          :name => "tester",
          :quantity => 7,
          :user => second_user,
          :value_in_cents => 107_02
        )
        Sale.create(
          :quantity => 4, 
          :widget => widget
        ).id
      end
      
      it "does not delete the widget" do
        expect do
          route

          response_obj = OpenStruct.new(JSON.parse(response.body))
          expect(response_obj.message).to eq("unauthorized")
        end.not_to change { Sale.count }
      end
    end
  end
end