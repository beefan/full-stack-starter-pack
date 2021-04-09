require 'rails_helper'

describe User do
  subject(:user) { described_class.new(user_params) }

  let(:username) { "giant_whale" }
  let(:email) { "giant_whale@ocean.org" }
  let(:password) { "secure" }
  let(:user_params) do { :email => email, :username => username, :password => password } end

  describe "validations: " do
    context "username must be present" do
      let(:user_params) do { :email => email, :password => password } end

      it "user not valid when username isn't present" do
        expect(user.save).to eq(false)
      end
    end

    context "email must be present" do
      let(:user_params) do { :username => username, :password => password } end

      it "user not valid when email isn't present" do
        expect(user.save).to eq(false)
      end
    end

    context "password required to create a user" do

      let(:user_params) do { :username => username, :email => email } end

      it "user not valid when password not present" do 
        expect(user.save).to eq(false)
      end
    end

    context "when all required params are present" do
      it "user is valid and saves" do
        expect do
          expect(user.save).to eq(true)
        end.to change { User.count }.by(1)
      end
    end
  end
end