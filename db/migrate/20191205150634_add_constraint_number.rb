class AddConstraintNumber < ActiveRecord::Migration[6.0]
  def change
    execute "ALTER TABLE users ADD CONSTRAINT check_wallet_than_zero CHECK (wallet >= 0)"
  end
end
