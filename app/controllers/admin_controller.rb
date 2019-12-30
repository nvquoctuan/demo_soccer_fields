class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user
  layout "admin/application"

  private

  def get_pitch pitch
    pitch.user_id
  end

  def check_pitch_owner pitch
    return unless check_owner?
    return if get_pitch(pitch) == current_user.id

    flash[:danger] = t "msg.danger_permission"
    redirect_to admin_pitches_path
  end
end
