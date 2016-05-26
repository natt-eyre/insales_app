class Image < ActiveRecord::Base
    belongs_to :product
    validates_presence_of :image_id
    
end