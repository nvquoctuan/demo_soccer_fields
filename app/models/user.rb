class User < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :pitches, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_ratings, dependent: :destroy
  has_many :active_recharge, class_name: Recharge.name,
                             foreign_key: :sender_id, dependent: :destroy
  has_many :passive_recharge, class_name: Recharge.name,
                              foreign_key: :receiver_id, dependent: :destroy

  has_many :receiver, through: :active_recharge
  has_many :sender, through: :passive_recharge

  before_save{email.downcase!}
  DATA_TYPE_USERS = %i(full_name email password password_confirmation).freeze
  DATA_TYPE_UPDATE_PROFILE =
    %i(full_name phone gender password password_confirmation).freeze
  DATA_TYPE_UPDATE_PROFILE_PROVIDER = %i(full_name phone gender).freeze
  DATA_TYPE_RESETS_PASSWORD = %i(password password_confirmation).freeze
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  VALID_PHONE_REGEX = /\A[\d]{10,}\z/i.freeze

  has_one_attached :avatar
  # validates :full_name, presence: true,
  #   length: {maximum: Settings.name_in_users_max}
  validates :email, presence: true,
    length: {maximum: Settings.email_in_users_max},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :phone, format: {with: VALID_PHONE_REGEX}, allow_nil: true
  validates :gender, inclusion: {in: [true, false],
                                 message: "Gender is valid"}, allow_nil: true
  validates :wallet, numericality: {greater_than_or_equal_to: 0},
    allow_nil: true

  enum role: {admin: 0, owner: 1, user: 2}

  scope :order_active, ->{order("activated DESC")}
  scope(:search, lambda do |search|
    if search
      where("full_name LIKE ? OR email LIKE ?", "%#{search}%", "%#{search}%")
    end
  end)

  scope :not_user, ->(user_id){where "id NOT IN (?)", user_id}
end
