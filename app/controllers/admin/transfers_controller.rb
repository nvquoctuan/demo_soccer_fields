class Admin::TransfersController < AdminController

  def index
    @transfers = Transfer.by_user(params[:receiver_id])
                         .search(params[:search])
                         .paginate page: params[:page],
                          per_page: Settings.size.s10
    @users = User.not_user current_user.id
  end

  def new
    @users = User.not_user(current_user.id)
    @transfer = current_user.active_transfer.build
  end

  def create
    ActiveRecord::Base.transaction do
      @transfer = current_user.active_transfer.build wallet_params
      @transfer.save!
      @user = User.find params[:transfer][:receiver_id].to_i
      if @user.update!(wallet: @user.wallet + params[:transfer][:money].to_i)
        flash[:success] = t "msg.transfer_success"
      end
      rescue ActiveRecord::RecordInvalid, ActiveRecord::RangeError
        flash[:danger] = t "msg.value_invalid"
      rescue ActiveRecord::RecordNotFound
        flash[:danger] = t "msg.user_notfound"
    end
    redirect_to admin_transfers_path
  end

  def destroy
    ActiveRecord::Base.transaction do
      @transfer = Transfer.find params[:id]
      @transfer.destroy!
      @user = User.find @transfer.receiver.id
      if @user.wallet - @transfer.money < 0
        flash[:danger] = t "msg.transfer_danger"
        raise ActiveRecord::Rollback
      end
      @user.update!(wallet: @user.wallet - @transfer.money)
      rescue ActiveRecord::RecordInvalid, ActiveRecord::RangeError
        flash[:danger] = t "msg.value_invalid"
      rescue ActiveRecord::RecordNotFound
        flash[:danger] = t "msg.user_notfound"
    end
    flash[:success] = t "msg.destroy_success"
    redirect_to admin_transfers_path
  end

  private

  def wallet_params
    params.require(:transfer).permit Transfer::PARAMS
  end
end
