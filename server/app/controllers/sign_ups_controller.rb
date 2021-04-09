class SignUpsController < ApplicationController
  def create 
    @user = User.new(_user_params)

    if @user.save
      render json: @user
    else
      render json: @user.errors
    end
  end

  private

  def _user_params
    params.require(:userDetails).permit(:email, :username, :password)
  end
end
