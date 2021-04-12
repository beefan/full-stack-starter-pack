module AuthenticationHelper
  PRIMARY_USER = 
    { 
      :userDetails => { 
        :username => "Frank1281", 
        :email => "itsme@mywebsite.com", 
        :password => "realsecure1!" 
      } 
    }.freeze
  SECONDARY_USER = 
    { 
      :userDetails => { 
        :username => "JohnAllen09", 
        :email => "thirty-seven-dogs@mywebsite.com", 
        :password => "a-big-secret" 
      } 
    }.freeze

  RSpec.shared_examples "route is protected" do
    context "when not logged in" do
      it "returns unauthorized message" do
        logout
        route
        
        response_obj = OpenStruct.new(JSON.parse(response.body))

        expect(response_obj.message).to eq("unauthorized")
      end
    end
  end

  def login
    @user ||= User.create(PRIMARY_USER[:userDetails])
    session[:user_id] = @user.id
  end

  def logout
    session[:user_id] = nil
  end
end