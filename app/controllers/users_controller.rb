class UsersController < ApplicationController
  before_action :require_login, only: [:index]
  before_action :skipped_if_login, only: [:new]

  def new
    @user = User.new
  end

  def index
    @users = User.all.shuffle
  end

  def create
    @user = User.new(get_user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to users_path, flash: {success: "Welcome #{@user.name}"}
    else
      redirect_to root_path, flash: {error: "Oops! Something goes wrong. #{@user.errors.messages.collect {|k, v| "#{k}: #{v.join(' and ')}"}.join(', ')}"}
    end
  end

  private

  def get_user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
