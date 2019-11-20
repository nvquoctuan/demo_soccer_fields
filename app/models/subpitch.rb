class Subpitch < ApplicationRecord
  belongs_to :pitch
  belongs_to :subpitch_type
  has_many :bookings, dependent: :destroy
  has_one_attached :picture
  scope :pitch, ->(pitch_id){where("pitch_id = \"?\"", pitch_id)}
end
