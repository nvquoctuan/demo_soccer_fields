class Pitch < ApplicationRecord
  PARAMS = %i(name description country city district address phone picture start_time end_time limit).freeze
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
  validates :phone, presence: true, numericality: true,
            length: {in: Settings.size.s6..Settings.size.s12}
  validates :end_time, date: {after: :start_time}
  validates :limit, presence: true, numericality: true,
            length: {in: Settings.size.s1..Settings.size.s2}
  validate :play_time_bigger_limit

  has_one_attached :picture

  scope :latest_pitches, ->{order created_at: :desc}

  scope :search, (lambda do |pitch_name|
    if pitch_name
      where("name LIKE ?", "%#{pitch_name}%")
    else
      all
    end
  end)

  scope(:search_pitches, lambda do |address|
    where("address LIKE ?", "%#{address}%")
  end)
  scope(:search_city, lambda do |city|
    where("city LIKE ?", "%#{city}%")
  end)
  scope(:search_district, lambda do |district|
    where("district LIKE ?","%#{district}%")
  end)

  # scope(:search_time, lambda do |time|
  #   search = ""
  #    time.each do |column, value, operator|
  #     if column.keys[0] && column.keys[1]
  #       (search += "OR") if search.present?
  #       search += "(#{column.keys[0]} #{column.values[1]} TIME('#{column.values[0]}'))"
  #     end
  #   end
  #   where(search) if search
  # end)
  scope(:search_time, lambda do |start_time, end_time|
    where("(start_time >= ? and start_time <= ?) or (end_time >= ? and end_time <= ?) or (start_time <= ? and end_time >= ?)", start_time, end_time, start_time, end_time, start_time, end_time )
  end)

  scope :pitch_owner, ->(id_user){where("user_id = ?", id_user)}

  scope(:revenue_pitch, lambda do
    joins(subpitches: :bookings)
    .select("sum(total_price) as total_pitch, pitches.*").group("pitches.id")
  end)

  scope :revenue_owner, ->(user_id){where("pitches.user_id = ?", user_id)}

  scope(:search_pitch, lambda do |search|
    where("(pitches.name LIKE ?) OR (pitches.city LIKE ?) OR
            (pitches.district LIKE ?) OR (address LIKE ?)",
          "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
  end)
  scope :active_booking, ->{where("bookings.status = 0")}
  scope :order_pitch, ->(order){order(total_pitch: order) if order}
  scope(:month_revenue, lambda do |month|
    if month
      where("(MONTH(bookings.start_time) = ?)
             AND (MONTH(bookings.end_time) = ?)", month, month)
    end
  end)

  scope(:year_revenue, lambda do |year|
    if year
      where("(YEAR(bookings.start_time) = ?) AND (YEAR(bookings.end_time) = ?)", year, year)
    end
  end)

  scope :order_sum, ->{order("total_pitch DESC")}

  class << self
    def to_csv(options = {})
      CSV.generate(options) do |csv|
        column_names.push "total_pitch"
        csv << column_names
        sum = 0;
        all.each do |row|
          csv << row.attributes.values_at(*column_names)
          sum += row.attributes.values_at("total_pitch").join.to_i
        end
        csv << ["TOTAL"]
        csv << [sum]
      end
    end
  end

  private

  def play_time_bigger_limit
    return if self.limit.nil?
    return if (self.end_time - self.start_time) / 3600 >= self.limit

    errors.add :play_time_invalid, I18n.t("msg.play_time_invalid")
  end
end
