require 'spec_helper'

describe ProductsController do
  render_views
  
  fixtures :accounts

  let :default_account do
    accounts(:default)
  end
  
  let :installed_app do
    MyApp.new(default_account.insales_subdomain, default_account.password)
  end
  
  describe "#create" do
    before do
      controller.stub(:authentication)
      controller.stub(:current_account) {default_account}
      controller.stub(:configure_api)
      insales_product = double(:insales_product,
        archived:                     false,
        available:                    true,
        canonical_url_collection_id:  "",
        category_id:                  1,
        created_at:                   "2016-05-21 14:22:17 +0300",
        is_hidden:                    false,
        sort_weight:                  nil,
        unit:                         "pce",
        short_description:            "",
        permalink:                    "",
        html_title:                   "",
        meta_keywords:                "",
        meta_description:             "",
        currency_code:                "",
        collections_ids:              [],
        images:                       [],
        option_names:                 [],
        properties:                   [],
        characteristics:              [],
        product_field_values:         [],
        variants:                     [],
        description:                  "",
        title:                        "Fresh updated product",
        id:                           1,
        updated_at:                   "2016-05-21 14:22:17 +0300")
      controller.stub(:get_products_from_api) {[insales_product]}
    end
    it "creates products for current account" do
      post :create
      
      expect(controller).to have_received(:get_products_from_api).once
      expect(response).to redirect_to(products_path)
      expect(Product.last.account).to eq default_account
    end
    
    it "updates products in local db with latest version" do
      # product with older insales_updated_at
      default_account.products.new(
        insales_product_id: 1,
        title: "Outdated product",
        insales_updated_at: "2016-05-20 14:22:17 +0300").save!
      
      post :create
      
      expect(Product.all.count).to eq 1
      expect(Product.last.title).to eq "Fresh updated product"
    end
  end
  
  
end
