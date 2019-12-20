class Admin::Pitches::RevenuesController < AdminController
  before_action :load_date
  before_action :load_pitch, ->{check_pitch_owner(@pitch)}, only: :show
  before_action :load_revenue_owner, :load_revenue_admin, only: :index

  def index
    @sum = sum_revenue(@revenues, :total_pitch) if @revenues
    respond_to do |format|
      format.html
      format.csv{send_data @revenues.to_csv}
      format.xls
    end
  end

  def show
    @search =  Subpitch.ransack params[:q]
    @revenue_details = @search.result.revenue_subpitch(@pitch)
                              .paginate page: params[:page],
                               per_page: Settings.size.s10
    @sum = sum_revenue @revenue_details, :total_subpitch
    respond_to do |format|
      format.html
      format.csv{send_data @revenue_details.to_csv}
      format.xls{send_data @revenue_details.to_csv(col_sep: "\t")}
    end
  end

  private

  def load_revenue_owner
    return unless check_owner?

    @search = Pitch.ransack params[:q]
    @revenues = @search.result.revenue_pitch.revenue_owner(current_user.id)
                       .active_booking
                       .paginate page: params[:page],
                        per_page: Settings.size.s10
  end

  def load_revenue_admin
    return unless check_admin?

    @search = Pitch.ransack params[:q]
    @revenues = @search.result.revenue_pitch.active_booking
                       .paginate page: params[:page],
                        per_page: Settings.size.s10
  end

  def sum_revenue revenues, column
    revenues.inject(0){|running_total,revenue| running_total + revenue[column]}
  end

  def load_pitch
    @pitch = Pitch.find_by id: params[:id]
    return if @pitch

    flash[:danger] = t "msg.danger_load"
    redirect_to revenue_admin_pitches_path
  end

  def load_date
    @year = params[:date][:year].to_i if params[:date]
    @month = params[:date][:month].to_i if params[:date]
  end
end
