require 'rails_helper'

describe SessionsController do
  let(:user_params) do 
    { 
      :userDetails => { :username => username, :email => email, :password => password } 
    }
  end
  let(:username) { "Frank1281" }
  let(:password) { "realsecure1!" }
  let(:email) { "itsme@mywebsite.com"}

  before do
    @user = User.create!(user_params[:userDetails])
  end

  describe ".create" do
    context "when user exists and password is valid" do
      it "creates a session" do
        get :create, :params => user_params
        
        response_obj = OpenStruct.new(JSON.parse(response.body))
        
        expect(session[:user_id]).to eq(@user.id)
        expect(response_obj.username).to eq(username)
      end
    end

    context "when password is invalid" do
      let(:wrong_username) { "Darwin86" }
      let(:wrong_password) { "I'm hacking" }
      let(:wrong_params) do 
        user_params.clone.tap do |params|
          params[:userDetails].update({ :username => wrong_username, :password => wrong_password })
        end
      end

      context "and user is invalid too" do
        it "does not create a session" do
          get :create, :params => wrong_params

          response_obj = OpenStruct.new(JSON.parse(response.body))

          expect(session[:user_id]).to be_nil
          expect(response_obj.error).to eq("Login Failed.")
        end
      end

      context "but user is valid" do
        let(:wrong_username) { username }

        it "does not create a session" do
          get :create, :params => wrong_params

          response_obj = OpenStruct.new(JSON.parse(response.body))

          expect(session[:user_id]).to be_nil
          expect(response_obj.error).to eq("Login Failed.")
        end
      end
    end
  end
  
  describe ".logout" do
    before do
      get :create, :params => user_params
    end

    it "clears the session" do
      expect(session[:user_id]).to eq(@user.id)
      get :logout
      expect(session[:user_id]).to be_nil
    end
  end
end