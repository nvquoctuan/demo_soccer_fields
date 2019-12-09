class Transfer < ApplicationRecord
  PARAMS = %i(content receiver_id money)
  belongs_to :sender, class_name: User.name
  belongs_to :receiver, class_name: User.name
  validates :sender_id, presence: true
  validates :receiver_id, presence: true
  validates :money, numericality: true
  validate :check_money

  scope :search, (lambda do |search|
    if search
      where "money = ? OR content LIKE ?", search.to_i, "%#{search}%"
    end
  end)

  scope :by_receiver, ->(user_id){where receiver: user_id if user_id}

  scope :by_user, (lambda do |user_id|
    where("receiver_id = ? OR sender_id = ?", user_id, user_id) if user_id
  end)

  private

  def check_money
    return if self.money > 0

    errors.add :money_invalid, I18n.t("msg.money_invalid")
  end
end
