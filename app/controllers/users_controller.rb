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
      redirect_to messages_path, flash: {success: "Welcome #{@user.name}"}
    else
      redirect_to root_path, flash: {error: "Oops! Something goes wrong. #{@user.errors.messages.collect {|k, v| "#{k}: #{v.join(' and ')}"}.join(', ')}"}
    end
  end

  def friend_request
    @friendable = current_user.friendables.build(:to_id => params[:id], accepted: "true") # accept by default
      if @friendable.save
        redirect_to messages_path, flash: {success: "Friend added"}
      else
        redirect_to messages_path, flash: {error: "Unable to request friendable"}
      end
  end

  private

  def get_user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
