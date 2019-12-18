class Admin::RechargesController < AdminController

  def index
    @recharges = Recharge.by_user(params[:receiver_id])
                         .search(params[:search])
                         .paginate page: params[:page],
                          per_page: Settings.size.s10
    @users = User.not_user current_user.id
  end

  def new
    @users = User.not_user(current_user.id)
    @recharge = current_user.active_recharge.build
  end

  def create
      ActiveRecord::Base.transaction do
        @recharge = current_user.active_recharge.build wallet_params
        @recharge.save!
        @user = User.find params[:recharge][:receiver_id].to_i
        if @user.update!(wallet: @user.wallet + params[:recharge][:money].to_i)
          flash[:success] = t "msg.recharge_success"
        end
        rescue ActiveRecord::RecordInvalid, ActiveRecord::RangeError
          flash[:danger] = t "msg.value_invalid"
        rescue ActiveRecord::RecordNotFound
          flash[:danger] = t "msg.user_notfound"
      end
    redirect_to admin_recharges_path
  end

  def destroy
    ActiveRecord::Base.transaction do
      @recharge = Recharge.find params[:id]
      @recharge.destroy!
      @user = User.find @recharge.receiver.id
      if @user.wallet - @recharge.money < 0
        flash[:danger] = t "msg.recharge_danger"
        raise ActiveRecord::Rollback
      end
      @user.update!(wallet: @user.wallet - @recharge.money)
      rescue ActiveRecord::RecordInvalid, ActiveRecord::RangeError
        flash[:danger] = t "msg.value_invalid"
      rescue ActiveRecord::RecordNotFound
        flash[:danger] = t "msg.user_notfound"
    end
    flash[:success] = t "msg.destroy_success"
    redirect_to admin_recharges_path
  end

  private

  def wallet_params
    params.require(:recharge).permit Recharge::PARAMS
  end
end
