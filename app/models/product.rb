class Product < ActiveRecord::Base
  validates_presence_of :insales_product_id
  belongs_to :account
  has_many :collections
  has_many :images
  has_many :option_names
  has_many :properties
  has_many :characteristics
  has_many :variants
  
  serialize :collections_ids, Array
  serialize :images, Array
  serialize :option_names, Array
  serialize :properties, Array
  serialize :characteristics, Array
  serialize :product_field_values, Array
  serialize :variants, Array

  def is_hidden?
    is_hidden ? "Да" : "Нет"
  end

  def to_param
    insales_product_id.to_s
  end
end
