module SubpitchesHelper
  def check_like subpitch
    Like.like_subpitch subpitch.id
  end

  def liked like
    Like.find_by id: like.ids.join("").to_i
  end

  def count_like subpitch
    Like.like_subpitch(subpitch.id).count(:id)
  end

  def check_like_rating rating
    LikeRating.find_by rating_id: rating.id, user_id: current_user.id
  end
end
