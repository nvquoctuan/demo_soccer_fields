class Pitch < ApplicationRecord
  belongs_to :user
  has_many :subpitches, dependent: :destroy

  NUMBER_FORMAT = /\A[\d]+\z/i.freeze
  PARAMS = %i(name description country city district address picture start_time
            end_time limit).freeze
  belongs_to :user

  validates :name, presence: true, length: {maximum: Settings.size.s50}
  validates :description, length: {maximum: Settings.size.s255}
  validates :country, :city, :district,
            presence: true, length: {maximum: Settings.size.s50}
  validates :address, presence: true, length: {maximum: Settings.size.s100}
  validates :phone, presence: true, format: {with: NUMBER_FORMAT},
            length: {in: Settings.size.s6..Settings.size.s10}
  validates :end_time, date: {after: :start_time}
  validates :limit, presence: true, format: {with: NUMBER_FORMAT},
            length: {in: Settings.size.s1..Settings.size.s2}

  has_one_attached :picture

  scope :search, (lambda do |pitch_name|
    if pitch_name
      where("name LIKE ?", "%#{pitch_name}%")
    else
      all
    end
  end)

  scope :latest_pitches, ->{order(created_at: :desc)}
end
