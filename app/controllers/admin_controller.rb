class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user
  layout "admin/application"

  private

  def check_admin?
    current_user.admin?
  end

  def check_owner?
    current_user.owner?
  end

  def check_admin
    return if current_user.admin?

    flash[:danger] = t "msg.danger_permission"
    redirect_to admin_root_path
  end

  def check_owner
    return if current_user.owner?

    flash[:danger] = t "msg.danger_permission"
    redirect_to admin_root_path
  end

  def check_user
    return unless current_user.user?

    redirect_to root_path
    flash[:danger] = t "admin.danger_permission"
  end

  def check_owner
    return if check_owner? || check_admin?

    flash[:danger] = t "msg.danger_permission"
    redirect_to root_path
  end

  def get_pitch pitch
    pitch.user_id
  end

  def check_pitch_owner pitch
    return unless check_owner?
    return if get_pitch(pitch) == current_user.id

    flash[:danger] = t "msg.danger_permission"
    redirect_to admin_pitches_path
  end

  def check_login
    return if logged_in?

    redirect_to root_path
    flash[:danger] = t "msg.login"
  end

  def check_user
    return unless current_user.user?

    redirect_to root_path
    flash[:danger] = t "msg.danger_permission"
  end
end
