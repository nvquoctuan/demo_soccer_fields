class SubpitchesController < ApplicationController
  before_action :load_pitch
  before_action ->{load_subpitch(params[:id])}, :check_subpitch, only: :show

  def index
    @subpitches = Subpitch.pitch(params[:pitch_id].to_i)
    @like = current_user.likes.build subpitch_id: params[:id] if user_signed_in?
  end

  def show
    @new_comment = Comment.new
    @ratings = @subpitch.ratings
    @comments = @subpitch.comments
  end

  private

  def load_pitch
    @pitch = Pitch.find_by id: params[:pitch_id]
    return if @pitch

    flash[:danger] = t "msg.danger_load"
    redirect_to root_path
  end

  def check_subpitch
    return if @subpitch.pitch_id == @pitch.id

    redirect_to pitch_subpitches_path(@pitch.id)
  end

  def load_subpitch params
    @subpitch = Subpitch.find_by id: params
    return if @subpitch

    flash[:danger] = t "msg.danger_load_subpitch"
    redirect_to root_path
  end
end
