require "open-uri"
class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create)
  before_action :load_user, except: %i(new create)
  before_action :correct_user, only: [:edit, :update]

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.avatar.attach(
        io: File.open(Settings.avatar_default_path),
        filename: Settings.default_avatar_name
      )
      @user.send_activation_email
      flash[:info] = t ".please_check_mail"
      redirect_to root_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update update_user_params
      flash[:success] = t ".profile_updated"
      redirect_to edit_user_path
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit User::DATA_TYPE_USERS
  end

  def update_user_params
    params[:user][:gender] = true if params[:user][:gender] == "1"
    params[:user][:gender] = false if params[:user][:gender] == "0"
    if @user.provider
      params.require(:user).permit User::DATA_TYPE_UPDATE_PROFILE_PROVIDER
    else
      params.require(:user).permit User::DATA_TYPE_UPDATE_PROFILE
    end
  end
end
