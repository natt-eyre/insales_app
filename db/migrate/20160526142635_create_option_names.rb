class CreateOptionNames < ActiveRecord::Migration
  def change
    create_table :option_names do |t|
      t.references :product, index: true, foreign_key: true
      t.integer :option_id, index: true, unique: true, null: false
      t.integer :position
      t.string :title
    end
  end
end
