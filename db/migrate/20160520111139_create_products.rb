class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.boolean :archived
      t.boolean :available
      t.integer :canonical_url_collection_id
      t.integer :category_id
      t.string  :insales_created_at
      t.boolean :is_hidden
      t.string  :sort_weight
      t.string  :unit
      t.text    :short_description
      t.string  :permalink
      t.string  :html_title
      t.string  :meta_keywords
      t.text    :meta_description
      t.string  :currency_code
      t.text    :description
      
      t.string :title
      t.integer :insales_product_id, index: true, null: false
      t.string :insales_updated_at, index: true

      t.timestamps
    end
    
    add_reference :products, :account, index: true, foreign_key: true
  end
end
