class LikeRating < ApplicationRecord
  belongs_to :rating
  belongs_to :user

  scope :by_rating, ->rating_id{where rating_id: rating_id}
end
