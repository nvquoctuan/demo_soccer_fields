class Transfer < ApplicationRecord
  PARAMS = %i(content receiver_id money)
  belongs_to :sender, class_name: User.name
  belongs_to :receiver, class_name: User.name
  validates :sender_id, presence: true
  validates :receiver_id, presence: true
  validates :money, numericality: true

  scope :search, (lambda do |search|
    if search
      where "money = ? OR content LIKE ?", search.to_i, "%#{search}%"
    end
  end)

  scope :by_receiver, ->(user_id){where receiver: user_id if user_id}
end
