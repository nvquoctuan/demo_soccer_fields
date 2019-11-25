class Admin::Subpitches::RatingsController < AdminController
  before_action :load_subpitch
  before_action :load_rating, :check_admin, only: :destroy
  before_action :load_rating_admin, :load_rating_owner, only: :index

  def index; end

  def destroy
    if @rating.destroy
      flash[:success] = t "msg.destroy_success"
    else
      flash[:danger] = t "msg.destroy_danger"
    end
    redirect_to admin_pitch_subpitch_ratings_path(@subpitch.pitch.id, @subpitch)
  end

  private

  def load_subpitch
    @subpitch = Subpitch.find_by id: params[:subpitch_id]
    return if @subpitch

    flash[:danger] = t "msg.danger_load"
    redirect_to admin_pitch_subpitches_path
  end

  def load_rating
    @rating = Rating.find_by id: params[:id]
    return if @rating

    flash[:danger] = t "msg.danger_load"
    redirect_to admin_pitch_subpitch_ratings(@subpitch.pitch.id, @subpitch)
  end

  def load_rating_admin
    return unless check_admin?

    @ratings = Rating.search_subpitch(@subpitch.id).search(params[:search])
                     .paginate page: params[:page],
                      per_page: Settings.size.s10
  end

  def load_rating_owner
    return unless check_owner?

    @ratings = Rating.search_owner(current_user.id)
                     .search_subpitch(@subpitch.id).search(params[:search])
                     .paginate page: params[:page],
                      per_page: Settings.size.s10
  end
end
