module Admin::TransfersHelper
  def check_transfer? transfer
    @transfer = Transfer.find transfer.id
    @receiver = @transfer.receiver
    return true if @receiver.wallet - @transfer.money < 0
    rescue ActiveRecord::RecordNotFound
      transfer.erorrs.add :name, :not_found
    false
  end
end
