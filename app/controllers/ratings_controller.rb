class RatingsController < ApplicationController
  def index
    @ratings = Rating.rating_user(current_user.id)
                     .paginate page: params[:page], per_page: Settings.size.s10
  end
end
