class Account < ActiveRecord::Base
  validates_presence_of :insales_id
  validates_presence_of :insales_subdomain
  validates_presence_of :password

  has_many :products

  def override_update_time(product)
    update_attributes!(updated_since: product.updated_at, last_id: product.id)
  end
end
