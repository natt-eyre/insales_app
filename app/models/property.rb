class Property < ActiveRecord::Base
    belongs_to :product
    validates_presence_of :property_id
end