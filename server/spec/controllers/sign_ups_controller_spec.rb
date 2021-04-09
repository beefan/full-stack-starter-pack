require 'rails_helper'
require 'json'

describe SignUpsController do
  let(:user_params) do 
    { 
      :userDetails => { :username => username, :email => email, :password => password } 
    }
  end
  let(:username) { "Frank1281" }
  let(:password) { "realsecure1!" }
  let(:email) { "itsme@mywebsite.com"}
  
  describe "#create" do
    describe "validations" do 
      context "when the username is not unique" do
        before do
          User.create!(user_params[:userDetails])
          user_params[:userDetails].update(:email => "a_unique_email@gmail.com")
        end

        it "does not save the user", :aggregate_failures do
          expect do 
            post :create, :params => user_params

            response_obj = OpenStruct.new(JSON.parse(response.body))

            expect(response_obj.username.first).to eq("has already been taken")
          end.to change { User.count }.by(0)
        end
      end

      context "when the email is not unique" do
        before do
          User.create!(user_params[:userDetails])
          user_params[:userDetails].update(:username => "a_unique_user")
        end

        it "does not save the user", :aggregate_failures do
          expect do 
            post :create, :params => user_params

            response_obj = OpenStruct.new(JSON.parse(response.body))

            expect(response_obj.email.first).to eq("has already been taken")
          end.to change { User.count }.by(0)
        end
      end
    end

    context "when username, email, and password are provided" do
      it "saves the user" do
        expect do
          post :create, :params => user_params

          response_obj = OpenStruct.new(JSON.parse(response.body))

          expect(response_obj.username).to eq(username)
        end.to change { User.count }.by(1)
      end
    end
  end
end