class Admin::BookingsController < AdminController
  before_action :load_booking_admin, :load_booking_owner, only: :index
  before_action :load_booking, :check_booking_owner, only: :update

  def index; end

  def update
    if @booking.update status: params[:booking][:status].to_i
      flash[:success] = t "msg.update_success"
    else
      flash[:danger] = t "msg.update_danger"
    end
    redirect_to admin_bookings_path
  end

  private

  def load_booking_admin
    return unless check_admin?

    @bookings = Booking.last_booking.booking_status(params[:status].to_i)
                       .search_booking(params[:search])
                       .paginate page: params[:page],
                        per_page: Settings.size.s10
  end

  def load_booking_owner
    return unless check_owner?

    @bookings = Booking.last_booking.booking_status(params[:status].to_i)
                       .booking_owner(current_user.id)
                       .search_booking(params[:search])
                       .paginate page: params[:page],
                        per_page: Settings.size.s10
  end

  def load_booking
    @booking = Booking.find_by id: params[:id]
    return if @booking

    flash[:danger] = t "msg.danger_load_booking"
    redirect_to admin_bookings_path
  end

  def check_booking_owner
    return unless check_owner?

    @booking = Booking.booking_owner(current_user.id).find_by id: params[:id]
  end
end
