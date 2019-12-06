class Admin::PagesController < AdminController
  before_action :load_info

  def home; end

  private

  def load_info
    @user = User.find current_user.id
    load_booking
    load_revenue
    load_rating
  end

  def load_booking
    if check_admin?
      @bookings = Booking.desc.limit 3
    else
      @bookings = Booking.desc.booking_owner(current_user.id).limit 3
    end
  end

  def load_revenue
    if check_admin?
      @revenues = Pitch.revenue_pitch.order_sum.limit 5
    else
      @revenues = Pitch.revenue_pitch.revenue_owner(current_user.id)
                       .order_sum.limit 5
    end
  end

  def load_rating
    if check_admin?
      @ratings = Rating.desc.limit 5
    else
      @ratings = Rating.by_owner(current_user.id).desc.limit 5
    end
  end
end
