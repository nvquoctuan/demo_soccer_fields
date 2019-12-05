class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :subpitch
  has_one :rating, dependent: :destroy
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :subpitch_id, presence: true
  validates :total_price, presence: true
  validate :check_status, on: :payment
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

  private

  def check_status
    return unless (Booking.find_by id: id).status.zero?

    errors.add :cant_repay, I18n.t("cant_repay")
  end
end
