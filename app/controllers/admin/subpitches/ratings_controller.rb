class Admin::Subpitches::RatingsController < AdminController
  before_action :load_subpitch, only: :show
  before_action :load_rating, :check_account_permission, only: :destroy
  before_action :load_rating_admin, :load_rating_owner, only: :index

  def index; end

  def show
    @ratings = Rating.search_subpitch(@subpitch.id)
                     .paginate page: params[:page],
                      per_page: Settings.size.s10
  end

  def destroy
    if @rating.destroy
      flash[:success] = t "msg.destroy_success"
    else
      flash[:danger] = t "msg.destroy_danger"
    end
    redirect_to get_path_destroy
  end

  private

  def load_subpitch
    @subpitch = Subpitch.find_by id: params[:subpitch_id]
    return if @subpitch

    flash[:danger] = t "msg.danger_load"
    redirect_to get_path
  end

  def check_account_permission
    return if check_admin?

    return if @rating.booking.subpitch.pitch.user_id == current_user.id

    flash[:danger] = t "msg.danger_permission"
    redirect_to get_path
  end

  def load_rating
    @rating = Rating.find_by id: params[:id]
    return if @rating

    flash[:danger] = t "msg.danger_load"
    redirect_to get_path
  end

  def get_path_destroy
    if request.referer.include?("subpitches")
      path = admin_pitch_subpitch_rating_path(@rating.booking.subpitch.pitch_id, @rating.booking.subpitch_id, @rating.booking.subpitch_id)
    else
      path = admin_ratings_path
    end
  end

  def get_path
     path = @subpitch ? admin_pitch_subpitch_rating_path(@subpitch.pitch_id, @rating, @rating) : admin_ratings_path
  end

  def load_rating_admin
    return unless check_admin?

    @search = Rating.ransack params[:q]
    @ratings = @search.result
                      .paginate page: params[:page],
                       per_page: Settings.size.s10
  end

  def load_rating_owner
    return unless check_owner?

    @search = Rating.ransack params[:q]
    @ratings = @search.result.by_owner(current_user.id)
                      .paginate page: params[:page],
                       per_page: Settings.size.s10
  end
end
