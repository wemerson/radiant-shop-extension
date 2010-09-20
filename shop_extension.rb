class ShopExtension < Radiant::Extension
  version "0.9"
  description "Core extension for the Radiant shop"
  url "http://github.com/squaretalent/radiant-shop-extension"
  
  extension_config do |config|
    config.gem 'activemerchant',      :version => '1.7.3', :lib => 'active_merchant'
    config.gem 'will_paginate',       :version => '2.3.14'
    config.gem 'radiant-layouts-extension', :version => '0.9.1', :lib => false

    unless ENV["RAILS_ENV"] = "production"
      config.gem 'rspec',             :version => '1.3.0'
      config.gem 'rspec-rails',       :version => '1.3.2'
      config.gem 'cucumber',          :verison => '0.8.5'
      config.gem 'cucumber-rails',    :version => '0.3.2'
      config.gem 'database_cleaner',  :version => '0.4.3'
      config.gem 'ruby-debug',        :version => '0.10.3'
      config.gem 'webrat',            :version => '0.7.1'
    end
  end
  
  UserActionObserver.instance.send :add_observer!, ShopProduct
  UserActionObserver.instance.send :add_observer!, ShopCategory
  UserActionObserver.instance.send :add_observer!, ShopOrder
  
  def activate
    
    # View Hooks
    unless defined? admin.products
      Radiant::AdminUI.send :include, Shop::Interface::Products
      
      admin.products    = Radiant::AdminUI.load_default_shop_products_regions
      admin.categories  = Radiant::AdminUI.load_default_shop_categories_regions
    end
    
    if admin.respond_to? :page
      admin.page.edit.add :layout_row, 'shop_category'
      admin.page.edit.add :layout_row, 'shop_product' 
    end
    
    # Tags
    Page.send :include, Shop::Tags::Core, Shop::Tags::Cart, Shop::Tags::Category, Shop::Tags::Item, Shop::Tags::Product
    
    # Model Includes
    Page.send :include, Shop::Models::Page
    Image.send :include, Shop::Models::Image
    
    # Controller Includes
    ApplicationController.send :include, Shop::Controllers::ApplicationController
    SiteController.send :include, Shop::Controllers::SiteController
    
    # Tabs3
    tab "Shop" do
      add_item "Products", "/admin/shop"
    end
    
    # Ensure there is always a shop prefix, otherwise we'll lose admin and pages
    Radiant::Config['shop.url_prefix'] = Radiant::Config['shop.url_prefix'].blank? ? 'shop' : Radiant::Config['shop.url_prefix']
    Radiant::Config['shop.product_layout']  ||= 'Product'
    Radiant::Config['shop.category_layout'] ||= 'Products'
    Radiant::Config['shop.order_layout']    ||= 'Order'
    
    Radiant::Config['shop.price_unit']      ||= '$'
    Radiant::Config['shop.price_precision'] ||= 2
    Radiant::Config['shop.price_seperator'] ||= '.'
    Radiant::Config['shop.price_delimiter'] ||= ','
  end
  
end
