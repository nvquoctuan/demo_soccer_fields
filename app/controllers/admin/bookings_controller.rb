class Admin::BookingsController < AdminController
  before_action :load_date, :load_booking_admin, :load_booking_owner, only: :index
  before_action :load_booking, :check_booking_owner, only: %i(edit update destroy)

  def index; end

  def update
    if @booking.update status: params[:booking][:status].to_i
      flash[:success] = t "msg.update_success"
    else
      flash[:danger] = t "msg.update_danger"
    end
    redirect_to admin_bookings_path
  end

  def destroy
    if @booking.destroy
      flash[:success] = t "msg.destroy_success"
    else
      flash[:danger] = t "msg.destroy_danger"
    end
    redirect_to admin_bookings_path
  end

  private

  def load_booking_admin
    return unless check_admin?

    @search = Booking.ransack params[:q]
    @bookings = @search.result.last_booking
                       .paginate page: params[:page],
                        per_page: Settings.size.s10
  end

  def load_booking_owner
    return unless check_owner?

    @search = Booking.ransack params[:q]
    @bookings = @search.result.last_booking
                       .booking_owner(current_user.id)
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

  def load_date
    if params[:date]
      @year = params[:date][:year].to_i
      @month = params[:date][:month].to_i
      @day = params[:date][:day].to_i
    end
  end
end
