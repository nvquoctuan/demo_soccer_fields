module Admin::RechargesHelper
  def check_recharge? recharge
    @recharge = Recharge.find recharge.id
    @receiver = @recharge.receiver
    return true if @receiver.wallet - @recharge.money < 0
    rescue ActiveRecord::RecordNotFound
      recharge.erorrs.add :name, :not_found
    false
  end
end
