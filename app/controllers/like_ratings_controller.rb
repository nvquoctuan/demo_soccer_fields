class LikeRatingsController < ApplicationController
  before_action :load_like_rating, only: :destroy

  def create
    @likerating = current_user.like_ratings.build rating_id:
                                            params[:likerating][:rating_id].to_i
    respond_to do |format|
      if @likerating.save
        format.js
      else
        format.js{flash[:danger] = t "msg.like_rating"}
      end
    end
  end

  def destroy
    respond_to do |format|
      if @likerating.destroy
        format.js
      else
        format.js{flash[:danger] = t "msg.unlike_rating"}
      end
    end
  end

  private

  def load_like_rating
    @likerating = LikeRating.find_by id: params[:id]
    return if @likerating

    flash[:danger] = t "msg.danger_load_like"
    redirect_to request.referer
  end
end
