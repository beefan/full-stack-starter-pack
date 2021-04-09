class SessionsController < ApplicationController
  def create
    @user = User.find_by_username(_user_params[:username])
    if @user&.authenticate(_user_params[:password])
      session[:user_id] = @user.id
      render json: @user
    else
      render json: { error: "Login Failed." }
    end
  end

  def logout
    session.clear if logged_in?
    render json: { success: true }
  end

  private 

  def _user_params
    params.require(:userDetails).permit(:username, :password)
  end
end