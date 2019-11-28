module BookingsHelper
  def get_path booking
    rating = Rating.find_by booking_id: booking.id
    return edit_booking_rating_path(booking, rating) if rating

    path_new booking
  end

  def get_path_form booking
    rating = Rating.find_by booking_id: booking.id
    return booking_rating_path(rating.booking_id, rating) if rating

    path_new booking
  end

  def path_new booking
    booking_ratings_path booking
  end
end
