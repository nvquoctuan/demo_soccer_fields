class Like < ApplicationRecord
  belongs_to :user
  belongs_to :subpitch

  scope(:like_subpitch, lambda do |subpitch_id|
    joins(:subpitch).where("subpitch_id = ?", subpitch_id)
  end)
end
