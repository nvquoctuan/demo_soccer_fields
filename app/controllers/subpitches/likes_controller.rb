class Subpitches::LikesController < SubpitchesController
  before_action :logged_in_user
  before_action ->{load_subpitch(params[:subpitch_id])}
  before_action :correct_user, only: :destroy
  before_action :load_like

  def create
    respond_to do |format|
      if @like.save
        format.js
      end
    end
  end

  def destroy
    respond_to do |format|
      if @liked.destroy
        format.js
      end
    end
  end

  private

  def correct_user
    @liked = current_user.likes.find_by id: params[:id]
    return if @liked

    redirect_to pitch_subpitches_path(@pitch)
  end

  def load_like
    @like = current_user.likes.build subpitch_id: params[:subpitch_id]
  end
end
