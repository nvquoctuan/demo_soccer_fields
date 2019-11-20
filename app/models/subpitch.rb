class Subpitch < ApplicationRecord
  belongs_to :pitch
  belongs_to :subpitch_type
  has_many :bookings, dependent: :destroy

  validates :name, presence: true, length: {maximum: Settings.size.s50}
  validates :description, length: {maximum: Settings.size.s255}
  validates :price_per_hour, presence: true, format: {with: NUMBER}
  validates :size, presence: true, length: {maximum: Settings.size.s50}

  delegate :name, to: :pitch, prefix: true
  delegate :name, to: :subpitch_type, prefix: true

  has_one_attached :picture

  scope :search, (lambda do |subpitch|
    if subpitch
      where("name LIKE ?", "%#{subpitch}%")
    else
      all
    end
  end)

  scope :pitch, ->(pitch_id){where("pitch_id = \"?\"", pitch_id)}

  scope(:revenue_subpitch, lambda do |pitch|
    joins(:bookings).where("subpitches.pitch_id = ?", pitch)
                    .select("subpitches.*, sum(bookings.total_price) as total")
                    .group("subpitches.id")
  end)
end
