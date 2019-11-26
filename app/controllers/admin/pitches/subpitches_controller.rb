class Admin::Pitches::SubpitchesController < AdminController
  before_action :load_subpitch, except: %i(index new create)
  before_action :load_info, only: %i(new edit)
  before_action :load_pitch
  before_action ->{check_pitch_owner(@pitch)}

  def index
    @subpitches = Subpitch.pitch(params[:pitch_id].to_i)
                          .search(params[:search])
                          .paginate page: params[:page],
                           per_page: Settings.size.s10
  end

  def show; end

  def new
    @subpitch = Subpitch.new
  end

  def create
    @subpitch = Subpitch.new subpitch_params
    if @subpitch.save
      flash[:success] = t ".success"
      redirect_to admin_pitch_subpitch_path(params[:subpitch][:pitch_id],
                                            @subpitch)
    else
      flash.now[:danger] = t ".danger"
      load_info
      render :new
    end
  end

  def edit; end

  def update
    if @subpitch.update subpitch_params
      flash[:success] = t ".success"
      redirect_to admin_pitch_subpitch_path(params[:subpitch][:pitch_id],
                                            @subpitch)
    else
      flash.now[:danger] = t ".danger"
      load_info
      render :edit
    end
  end

  def destroy
    if @subpitch.destroy
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".danger"
    end
    redirect_to admin_pitch_subpitches_path
  end

  private

  def load_subpitch
    @subpitch = Subpitch.find_by id: params[:id]
    return if @subpitch

    flash.now[:danger] = t ".admin.subpitchs.danger_load"
    redirect_to admin_pitch_subpitches_path
  end

  def subpitch_params
    params.require(:subpitch).permit Subpitch::PARAMS
  end

  def load_info
    @pitches = check_owner? ? Pitch.pitch_owner(current_user.id) : Pitch.all
    @subpitch_types = SubpitchType.all
  end

  def load_pitch
    @pitch = Pitch.find_by id: params[:pitch_id]
    return if @pitch

    flash[:danger] = t "msg.danger_permission"
    redirect_to admin_pitches_path
  end
end
