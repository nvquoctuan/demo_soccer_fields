class Rating < ApplicationRecord
  PARAMS = %i(content star user_id).freeze
  NUMBER = /\A[1-5]{1}\z/i.freeze

  belongs_to :user
  belongs_to :booking

  validates :content, presence: true, length: {minimum: Settings.size.s10}
  validates :star, presence: true, format: {with: NUMBER}

  delegate :start_time, :end_time, to: :subpitch, prefix: true
  delegate :status, :total_price, to: :booking, prefix: true

  scope(:rating_user, lambda do |user_id|
    where("ratings.user_id = ?", user_id)
  end)

  scope(:search, lambda do |search|
    joins(booking: :subpitch).where("(subpitches.name LIKE ?) OR
      (ratings.content LIKE ?)", "%#{search}%", "%#{search}%")
  end)
end
