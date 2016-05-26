class CreateOptionValues < ActiveRecord::Migration
  def change
    create_table :option_values do |t|
      t.references :variant, index: true, foreign_key: true
      t.integer :option_value_id, null: false, unique: true, index: true
      t.integer :option_name_id
      t.integer :position
      t.string :title
    end
  end
end
