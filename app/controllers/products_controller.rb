class ProductsController < ApplicationController

  def index
    products_list
  end
  
  def update_products_list
    updated_since = nil
    last_id = nil
    InsalesApi::Product.find_updated_since(updated_since, {from_id: last_id}) {|items| @products = items}
    p @products
    redirect_to products_path
  end
  
  def products_list
    p @products
    p "---------------"
    @products
  end
  
end