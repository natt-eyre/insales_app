class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.references :product, index: true, foreign_key: true
      t.integer :property_id, index: true, unique: true, null: false
      t.boolean :backoffice
      t.boolean :is_hidden
      t.boolean :is_navigational
      t.integer :position
      t.string :permalink
      t.string :title
    end
  end
end
