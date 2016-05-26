class OptionName < ActiveRecord::Base
    belongs_to :product
    validates_presence_of :option_id
end