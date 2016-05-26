class Variant < ActiveRecord::Base
    belongs_to :product
    has_many :option_values
    validates_presence_of :variant_id
end