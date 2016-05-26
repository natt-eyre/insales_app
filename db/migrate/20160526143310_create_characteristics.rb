class CreateCharacteristics < ActiveRecord::Migration
  def change
    create_table :characteristics do |t|
      t.references :product, index: true, foreign_key: true
      t.integer :char_id, index: true, null: false, unique: true
      t.integer :position
      t.integer :property_id
      t.string :title
      t.string :permalink
    end
  end
end
