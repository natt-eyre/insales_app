class Characteristic < ActiveRecord::Base
  validates_presence_of :char_id
  belongs_to :product
end