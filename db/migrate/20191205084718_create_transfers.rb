class CreateTransfers < ActiveRecord::Migration[6.0]
  def change
    create_table :transfers do |t|
      t.bigint :sender_id
      t.bigint :receiver_id
      t.string :content
      t.decimal :money

      t.timestamps
    end
    add_index :transfers, :sender_id
    add_index :transfers, :receiver_id
  end
end
