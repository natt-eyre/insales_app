class Product < ActiveRecord::Base
  validates_presence_of :insales_product_id
  belongs_to :account
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
end
