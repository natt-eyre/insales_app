class ProductsController < ApplicationController

  def index
    get_products_from_db
  end
  
  def create
    get_products_from_api.each do |p|
      destroy_if_already_in_db(p)
      current_account.products.new(
        archived:                     p.archived,
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
        insales_updated_at:           p.updated_at
        ).save!
    end
    redirect_to products_path
  end

  private

  def get_products_from_api
    InsalesApi::Product.find_updated_since(updated_since, {from_id: last_id}) {|items| @insales_products = items.elements}
    @insales_products
  end

  def destroy_if_already_in_db(insales_product)
    if product_in_db = current_account.products.find_by(insales_product_id: insales_product.id)
      product_in_db.destroy
    end
  end

  def updated_since
    get_products_from_db.first.try(:insales_updated_at)
  end

  def last_id
    get_products_from_db.first.try(:id)
  end

  def get_products_from_db
    @products ||= current_account.products.order(insales_updated_at: :desc).all
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
