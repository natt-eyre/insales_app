class ProductsController < ApplicationController
  before_action :get_product, only: [ :show, :update]

  def index
    @products = get_products_from_db
  end

  def create
    get_products_from_api.each do |p|
      if product_in_db = already_in_db(p)
        update_products(product_in_db, p)
      else
        ActiveRecord::Base.transaction do
          current_account.products.new(
            product_params(p)
          ).save!
          @product = current_account.products.find_by_insales_product_id(p.id)
          p.collections_ids.each do |id|
            @product.collections.new(collection_id: id).save!
          end
          p.images.each do |image|
            @product.images.new(image_params(image)).save!
          end
          p.option_names.each do |option_name|
            @product.option_names.new(option_name_params(option_name)).save!
          end
          p.properties.each do |property|
            @product.properties.new(property_params(property)).save!
          end
          p.characteristics.each do |characteristic|
            @product.characteristics.new(characteristic_params(characteristic)).save!
          end
          p.variants.each do |variant|
            @product.variants.new(variant_params(variant)).save!
            variant.option_values.each do |option_value|
              @product.variants.find_by_variant_id(variant.id).option_values.new(option_value_params(option_value)).save!
            end
          end
        end
      end
    end
    redirect_to products_path
  end
  
  def show
    @images = @product.images.map(&:original_url)
    @variants = @product.variants
    @insales_product_url = insales_product_url
  end
  
  def update_products(product_in_db, insales_product)
    ActiveRecord::Base.transaction do
      # products table update
      product_in_db.update_attributes!( product_params(insales_product) )
      # collections table update
      (product_in_db.collections.map(&:id) - insales_product.collections_ids).each do |id|
        if collection = product_in_db.collections.find_by_collection_id(id)
          collection.destroy!
        end
      end
      (insales_product.collections_ids - product_in_db.collections.map(&:id)).each do |id|
        product_in_db.collections.new(collection_id: id).save!
      end
      # images table update
      (product_in_db.images.map(&:image_id) - insales_product.images.map(&:id)).each do |id|
        if image = product_in_db.images.find_by_image_id(id)
          image.destroy!
        end
      end
      (insales_product.images.map(&:id) - product_in_db.images.map(&:image_id)).each do |id|
        product_in_db.images.new(image_params(get_image(insales_product, id)))
      end
      (insales_product.images.map(&:id) & product_in_db.images.map(&:image_id)).each do |id|
        if image = product_in_db.images.find_by_image_id(id)
          image.update_attributes!(image_params(get_image(insales_product, id)))
        end
      end
      # option names table update
      (product_in_db.option_names.map(&:option_id) - insales_product.option_names.map(&:id)).each do |id|
        if option_name = product_in_db.option_names.find_by_option_id(id)
          option_name.destroy!
        end
      end
      (insales_product.option_names.map(&:id) - product_in_db.option_names.map(&:option_id)).each do |id|
        product_in_db.option_names.new(option_name_params(get_option_name(insales_product, id)))
      end
      (insales_product.option_names.map(&:id) & product_in_db.option_names.map(&:option_id)).each do |id|
        if option_name = product_in_db.option_names.find_by_option_id(id)
          option_name.update_attributes!(option_name_params(get_option_name(insales_product, id)))
        end
      end
      # properties table update
      (product_in_db.properties.map(&:property_id) - insales_product.properties.map(&:id)).each do |id|
        if property = product_in_db.properties.find_by_property_id(id)
          property.destroy!
        end
      end
      (insales_product.properties.map(&:id) - product_in_db.properties.map(&:property_id)).each do |id|
        product_in_db.properties.new(property_params(get_property(insales_product, id)))
      end
      (insales_product.properties.map(&:id) & product_in_db.properties.map(&:property_id)).each do |id|
        if property = product_in_db.properties.find_by_property_id(id)
          property.update_attributes!(property_params(get_property(insales_product, id)))
        end
      end
      # characteristics table update
      (product_in_db.characteristics.map(&:char_id) - insales_product.characteristics.map(&:id)).each do |id|
        if characteristic = product_in_db.characteristics.find_by_char_id(id)
          characteristic.destroy!
        end
      end
      (insales_product.characteristics.map(&:id) - product_in_db.characteristics.map(&:char_id)).each do |id|
        product_in_db.characteristics.new(characteristic_params(get_characteristic(insales_product, id)))
      end
      (insales_product.characteristics.map(&:id) & product_in_db.characteristics.map(&:char_id)).each do |id|
        if characteristic = product_in_db.characteristics.find_by_char_id(id)
          characteristic.update_attributes!(characteristic_params(get_characteristic(insales_product, id)))
        end
      end
      # variants table update
      (product_in_db.variants.map(&:variant_id) - insales_product.variants.map(&:id)).each do |id|
        if variant = product_in_db.variants.find_by_variant_id(id)
          variant.destroy!
        end
      end
      (insales_product.variants.map(&:id) - product_in_db.variants.map(&:variant_id)).each do |id|
        product_in_db.variants.new(variant_params(get_variant(insales_product, id)))
      end
      (insales_product.variants.map(&:id) & product_in_db.variants.map(&:variant_id)).each do |id|
        if variant = product_in_db.variants.find_by_variant_id(id)
          variant.update_attributes!(variant_params(get_variant(insales_product, id)))
        end
      end
      # option values table update
      product_in_db.variants.each do |variant|
        (variant.option_values.map(&:option_value_id) - get_variant(insales_product, variant.variant_id).option_values.map(&:id)).each do |id|
          if option_value = variant.option_values.find_by_option_value_id(id)
            option_value.destroy!
          end
        end
        (get_variant(insales_product, variant.variant_id).option_values.map(&:id) - variant.option_values.map(&:option_value_id)).each do |id|
          variant.option_values.new(option_value_params(get_option_value(insales_product, variant, id)))
        end
        (get_variant(insales_product, variant.variant_id).option_values.map(&:id) & variant.option_values.map(&:option_value_id)).each do |id|
          if option_value = variant.option_values.find_by_option_value_id(id)
            option_value.update_attributes!(option_value_params(get_option_value(insales_product, variant, id)))
          end
        end
      end
    end
  end

  def update
    update_products(@product, get_product_from_api)
    redirect_to @product
  end

  private

  def get_image(insales_product, id)
    insales_product.images.each { |i| return i if i.id == id }
  end

  def get_option_name(insales_product, id)
    insales_product.option_names.each { |i| return i if i.id == id }
  end

  def get_property(insales_product, id)
    insales_product.properties.each { |i| return i if i.id == id }
  end

  def get_characteristic(insales_product, id)
    insales_product.characteristics.each { |i| return i if i.id == id }
  end

  def get_variant(insales_product, id)
    insales_product.variants.each { |i| return i if i.id == id }
  end

  def get_option_value(insales_product, variant, id)
    get_variant(insales_product, variant.variant_id).option_values.each { |i| return i if i.id == id }
  end

  def image_params(image)
    {
      image_id: image.id,
      insales_created_at: image.created_at,
      position: image.position,
      original_url: image.original_url,
      title: image.title,
      filename: image.filename
    }
  end

  def option_name_params(option_name)
    {
      option_id: option_name.id,
      position: option_name.position,
      title: option_name.title
    }
  end

  def property_params(property)
    {
      property_id: property.id,
      backoffice: property.backoffice,
      is_hidden: property.is_hidden,
      is_navigational: property.is_navigational,
      position: property.position,
      permalink: property.permalink,
      title: property.title
    }
  end

  def characteristic_params(characteristic)
    {
      char_id: characteristic.id,
      property_id: characteristic.property_id,
      position: characteristic.position,
      permalink: characteristic.permalink,
      title: characteristic.title
    }
  end

  def variant_params(variant)
    {
      variant_id: variant.id,
      title: variant.title,
      quantity: variant.quantity,
      barcode: variant.barcode,
      cost_price: variant.cost_price,
      old_price: variant.old_price,
      price: variant.price,
      price2: variant.price2,
      sku: variant.sku,
      ins_created_at: variant.created_at,
      ins_updated_at: variant.updated_at,
      weight: variant.weight
    }
  end

  def option_value_params(option_value)
    {
      option_value_id: option_value.id,
      option_name_id: option_value.option_name_id,
      position: option_value.position,
      title: option_value.title
    }
  end

  def get_products_from_api
    InsalesApi::Product.find_updated_since(current_account.updated_since,
      {from_id: current_account.last_id}) {|items| @insales_products = items.elements}
    current_account.override_update_time(@insales_products.last)
    @insales_products
  end

  def get_product_from_api
    InsalesApi::Product.find(params[:id])
  end

  def already_in_db(insales_product)
    current_account.products.find_by(insales_product_id: insales_product.id)
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
        description:                  p.description,
        title:                        p.title,
        insales_product_id:           p.id,
        insales_updated_at:           p.updated_at}
  end

  def insales_product_url
    "http:/#{current_account.insales_subdomain}/admin2/products/#{@product.insales_product_id}"
  end
  
  def get_product
    @product = current_account.products.find_by_insales_product_id(params[:id])
  end
end
