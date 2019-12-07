class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :subpitch
  has_one :rating, dependent: :destroy

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :subpitch_id, presence: true
  validates :total_price, presence: true
  validate :check_status, on: :payment

  enum status: {"Verifiled and paid": 0,
                "Verifiled and not pay": 1, "Unverifile": 2}

  delegate :full_name, to: :user, prefix: true
  delegate :name, to: :subpitch, prefix: true

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

  scope(:booking_owner, lambda do |id_user|
    includes(subpitch: :pitch).includes(:user)
                              .where(pitches: {user_id: id_user})
  end)

  scope :last_booking, ->{order(id: :desc)}

  scope(:booking_status, lambda do |status|
    where(bookings: {status: status}) if status != 3
  end)

  scope(:search_booking, lambda do |search|
    joins(:subpitch).where("subpitches.name LIKE ?", "%#{search}%") if search
  end)

  scope :by_year, (lambda do |year|
    if year
      where("(YEAR(bookings.start_time) = ?)
             AND (YEAR(bookings.end_time) = ?)", year, year)
    end
  end)

  scope :by_month, (lambda do |month|
    if month
      where("(MONTH(bookings.start_time) = ?)
             AND (MONTH(bookings.end_time) = ?)", month, month)
    end
  end)

  scope :by_day, (lambda do |day|
    if day
      where("(DAY(bookings.start_time) = ?)
             AND (DAY(bookings.end_time) = ?)", day, day)
    end
  end)

  private

  def check_status
    return unless Booking.statuses[(Booking.find_by id: id).status].zero?

    errors.add :cant_repay, I18n.t("cant_repay")
  end
end
