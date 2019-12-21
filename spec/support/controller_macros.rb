FactoryBot.define do
  module ControllerMacros
    def login_admin
      before(:each) do
        @request.env["devise.mapping"] = Devise.mappings[:admin]
        sign_in FactoryBot.create(:user, role: 0)
      end
    end

    def login_user
      # Before each test, create and login the user
      before(:each) do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        user = FactoryBot.create(:user)
        sign_in user
      end
    end



  end
end
