class CreatePriceItems < ActiveRecord::Migration[8.1]
  def change
    create_table :price_items do |t|
      t.string :category, null: false
      t.string :name, null: false
      t.string :unit
      t.decimal :price, precision: 10, scale: 2
      t.string :note
      t.integer :position, null: false, default: 0

      t.timestamps
    end
    add_index :price_items, [ :category, :position ]
  end
end
