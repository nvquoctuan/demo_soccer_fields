class CreateSubpitches < ActiveRecord::Migration[6.0]
  def change
    create_table :subpitches do |t|
      t.string :name
      t.string :description
      t.integer :status
      t.references :pitch, null: false, foreign_key: true
      t.decimal :price_per_hour
      t.string :currency
      t.text :picture
      t.string :size
      t.references :subpitch, null: false, foreign_key: true

      t.timestamps
    end
  end
end
