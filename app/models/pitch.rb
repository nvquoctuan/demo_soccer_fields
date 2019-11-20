class Pitch < ApplicationRecord
  NUMBER_FORMAT = /\A[\d]+\z/i.freeze
  PARAMS = %i(name description country city district address picture start_time
            end_time limit).freeze
  PARAMS1 = %i(name description country city district address picture phone
              start_time(4i) start_time(5i)
              end_time(4i) end_time(5i) limit).freeze
  belongs_to :user

  has_many :subpitches, dependent: :destroy

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

  scope :latest_pitches, ->{order(created_at: :desc)}

  scope :search, (lambda do |pitch_name|
    if pitch_name
      where("name LIKE ?", "%#{pitch_name}%")
    else
      all
    end
  end)

  scope :pitch_owner, ->(id_user){where("user_id = ?", id_user)}

  scope(:revenue_pitch, lambda do
    joins(subpitches: :bookings)
    .select("pitches.*, sum(total_price) as total").group("pitches.id")
  end)

  scope :revenue_owner, ->(user_id){where("pitches.user_id = ?", user_id)}

  scope(:search_pitch, lambda do |search|
    where("(pitches.name LIKE ?) OR (pitches.city LIKE ?) OR
            (pitches.district LIKE ?) OR (address LIKE ?)",
          "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
  end)
  scope :active_booking, ->{where("bookings.status = 0")}
  scope :order_pitch, ->(order){order(total: order) if order}
  scope(:month_revenue, lambda do |month|
    if month
      where("(MONTH(bookings.start_time) = ?)
             AND (MONTH(bookings.end_time = ?))", month, month)
    end
  end)

  scope(:year_revenue, lambda do |year|
    if year
      where("(YEAR(bookings.start_time) = ?) AND (YEAR(bookings.end_time = ?))",
            year, year)
    end
  end)
end
