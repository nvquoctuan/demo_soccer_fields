module Bookings::RatingsHelper
  def check_rating booking
    Booking.last_booking.where("id = ? AND status = 0", booking.id).check_display_rating Time.zone.now
  end
end
