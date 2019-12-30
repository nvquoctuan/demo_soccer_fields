module DeviseRequestRspecHelper
  def sign_in user = double("user")
    if user.nil?
      allow(request.env["warden"]).to receive(:authenticate!).and_throw(warden: {scope: :user})
      allow(controller).to receive(:current_user).and_return(nil)
    else
      allow(request.env["warden"]).to receive(:authenticate!)
      allow(controller).to receive(:current_user).and_return(current_user)
    end
  end
end
