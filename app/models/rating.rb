class Rating < ApplicationRecord
  PARAMS = %i(content star user_id).freeze
  NUMBER = /\A[1-5]{1}\z/i.freeze

  belongs_to :user
  belongs_to :booking

  validates :content, presence: true, length: {minimum: Settings.size.s10}
  validates :star, presence: true, format: {with: NUMBER}
end
