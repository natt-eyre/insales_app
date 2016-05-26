class CreateVariants < ActiveRecord::Migration
  def change
    create_table :variants do |t|
      t.references :product, index: true, foreign_key: true
      t.integer :variant_id, index: true, null: false, unique: true
      t.string :barcode
      t.decimal :cost_price
      t.decimal :old_price
      t.decimal :price
      t.decimal :price2
      t.string :sku
      t.datetime :ins_created_at
      t.datetime :ins_updated_at
      t.string :title
      t.integer :quantity
    end
  end
end
