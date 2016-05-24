class AddColumnsToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :updated_since, :string
    add_column :accounts, :last_id, :integer
  end
end
