class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.references :product, index: true, foreign_key: true
      t.integer :collection_id, index: true
      
      t.timestamps
    end
  end
end
