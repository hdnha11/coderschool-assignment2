class SessionsController < ApplicationController
  before_action :skipped_if_login, only: [:new]

  def new
  end

  def create
    email = params[:user][:email]
    password = params[:user][:password]

    user = User.find_by_email(email)

    if user && user.authenticate(password)
      session[:user_id] = user.id
      redirect_to messages_path, flash: {success: "Welcome #{user.name}"}
    else
      redirect_to login_path, flash: {error: "Email or password is incorrect. Please try again!"}
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  def callback
    if user = User.from_omniauth(env["omniauth.auth"])
      session[:user_id] = user.id
      redirect_to messages_path, flash: {success: "Welcome #{user.name}"}
    else
      redirect_to root_path, flash: {error: "Cannot login with Facebook. Please try again!"}
    end
  end
end
