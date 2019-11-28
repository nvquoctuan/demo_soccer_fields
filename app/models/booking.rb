class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :subpitch
  has_one :rating, dependent: :destroy

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :subpitch_id, presence: true
  validates :total_price, presence: true
  validate :check_status, on: :payment

  delegate :full_name, to: :user, prefix: true
  delegate :name, to: :subpitch, prefix: true
  enum status: {"Verifiled and paid": 0,
                "Verifiled and not pay": 1, "Unverifile": 2 }

  scope :inschedule, lambda{|start_time_schedule|
    where "date_format(start_time, \"%H%i\") >= ?",
          start_time_schedule.strftime("%H%M")
  }
  scope :today, lambda{
    where "date_format(start_time, \"%Y%m%d\") = ?",
          Time.zone.today.strftime("%Y%m%d")
  }
  scope :have_not_been_canceled, ->{where "status <> #{Settings.canceled}"}
  scope :asc, ->{order(created_at: :asc)}
  scope :desc, ->{order(created_at: :desc)}

  scope(:booking_user, lambda do |user_id|
    joins(:user).joins(:subpitch).where(bookings: {user_id: user_id})
  end)

  scope(:search_booking, lambda do |search|
    where("(subpitches.name LIKE ?) OR (bookings.total_price = ?)",
          "%#{search}%", search)
  end)

  private

  def check_status
    return unless (Booking.find_by id: id).status.zero?

    errors.add :cant_repay, I18n.t("cant_repay")
  end
end
