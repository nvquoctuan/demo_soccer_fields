class AdminController < ApplicationController
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
end
