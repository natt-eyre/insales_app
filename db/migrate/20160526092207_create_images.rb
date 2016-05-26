class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.references :product, index: true, foreign_key: true
      t.integer :image_id, index: true, null: false, unique: true
      t.datetime :insales_created_at
      t.integer :position
      t.string :original_url
      t.string :title
      t.string :filename
      
      t.timestamps
    end
  end
end
