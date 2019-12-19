require "open-uri"
class UsersController < ApplicationController
  layout :load_layout
  before_action :load_user, except: %i(index new create)
  before_action :authenticate_user!, only: %i(index destroy show)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy index)

  def index
    @users = User.order_confirm.search(params[:search])
                 .paginate page: params[:page], per_page: Settings.size.s10
  end

  def show; end

  def destroy
    if @user.destroy
      flash[:success] = t "msg.destroy_success"
      redirect_to admin_users_path
    else
      flash.now[:success] = t "msg.destroy_danger"
      redirect_to admin_root_path
    end
  end

  private

  def admin_user
    authorize! :read, current_user
  end

  def load_layout
    @link = request.original_url.include?("admin") ? "admin" : nil
    @link ? "admin/application" : "application"
  end
end
