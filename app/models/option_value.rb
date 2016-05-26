class OptionValue < ActiveRecord::Base
  validates_presence_of :option_value_id
  belongs_to :variant
end