class Product < ActiveRecord::Base
    validates_presence_of :insales_product_id
    belongs_to :account
end