class ProductsController < ApplicationController

  def index
    @products = get_products_from_db
  end

  def create
    get_products_from_api.each do |p|
      if already_in_db(p)
        update_product(already_in_db(p), p)
      else
        current_account.products.new(
          product_params(p)
        ).save!
      end
    end
    redirect_to products_path
  end
  
  def show
    @product = current_account.products.find_by_insales_product_id(params[:id])
    @images = @product.images.map(&:original_url)
    @variants = @product.variants
    @insales_product_url = insales_product_url
  end

  private

  def get_products_from_api
    InsalesApi::Product.find_updated_since(current_account.updated_since,
      {from_id: current_account.last_id}) {|items| @insales_products = items.elements}
    current_account.override_update_time(@insales_products.last)
    @insales_products
  end

  def already_in_db(insales_product)
    @product_in_db ||= current_account.products.find_by(insales_product_id: insales_product.id)
  end

  def update_product(product_in_db, insales_product)
      product_in_db.update_attributes!(
        product_params(insales_product)
        )
  end

  def get_products_from_db
    current_account.products.order(insales_updated_at: :desc).all
  end

  def product_params(p)
      {archived:                     p.archived,
        available:                    p.available,
        canonical_url_collection_id:  p.canonical_url_collection_id,
        category_id:                  p.category_id,
        insales_created_at:           p.created_at,
        is_hidden:                    p.is_hidden,
        sort_weight:                  p.sort_weight,
        unit:                         p.unit,
        short_description:            p.short_description,
        permalink:                    p.permalink,
        html_title:                   p.html_title,
        meta_keywords:                p.meta_keywords,
        meta_description:             p.meta_description,
        currency_code:                p.currency_code,
        collections_ids:              p.collections_ids,
        images:                       p.images,
        option_names:                 p.option_names,
        properties:                   p.properties,
        characteristics:              p.characteristics,
        product_field_values:         p.product_field_values,
        variants:                     p.variants,
        description:                  p.description,
        title:                        p.title,
        insales_product_id:           p.id,
        insales_updated_at:           p.updated_at}
  end

  def insales_product_url
    "http:/#{current_account.insales_subdomain}/admin2/products/#{@product.insales_product_id}"
  end

  # def product_params
  #   params.require(:product).permit(:archived, 
  #                                   :available,
  #                                   :canonical_url_collection_id,
  #                                   :category_id,
  #                                   :insales_created_at,
  #                                   :is_hidden,
  #                                   :sort_weight,
  #                                   :unit,
  #                                   :short_description,
  #                                   :permalink,
  #                                   :html_title,
  #                                   :meta_keywords,
  #                                   :meta_description,
  #                                   :currency_code,
  #                                   :collections_ids,
  #                                   :images,
  #                                   :option_names,
  #                                   :properties,
  #                                   :characteristics,
  #                                   :product_field_values,
  #                                   :variants,
  #                                   :description,
  #                                   :title,
  #                                   :insales_product_id,
  #                                   :insales_updated_at
  #                                   )
  # end
  
end
