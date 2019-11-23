class Pitch < ApplicationRecord
  belongs_to :user
  has_many :subpitches, dependent: :destroy

  scope :latest_pitches, ->{order(created_at: :desc)}
end
