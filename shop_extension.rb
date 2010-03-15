require_dependency 'application_controller'

require 'ostruct'
require 'acts_as_list'

class ShopExtension < Radiant::Extension
  version "0.7"
  description "Core extension for the Radiant shop"
  url "http://github.com/squaretalent/radiant-shop-extension"
  
  define_routes do |map|
    #allows us to pass category to a product
    map.new_admin_shop_product 'admin/shop/products/new/:category', :controller => 'admin/shop/products', :action => 'new'
    map.namespace :admin, :member => {:remove => :get} do |admin|
      admin.namespace :shop, :member => {:remove => :get} do |shop|
        shop.resources :categories, :as => 'products/categories'
        shop.resources :products
        shop.resources :customers
        shop.resources :orders
      end
    end
    map.namespace 'shop' do |shop|
      shop.connect 'category/:title', :controller => 'categories', :action => 'show', :name => /([\w\_]+)\z?/
      shop.connect 'product/:title', :controller => 'products', :action => 'show', :name => /([\w\_]+)\z?/
    end
  end
  
  extension_config do |config|
    config.gem 'will_paginate', :version => '~> 2.3.11', :source => 'http://gemcutter.org'
    config.extension 'login_candy'
  end
  
  def activate
    tab 'Shop' do
      add_item 'Products', '/admin/shop/products'
      add_item 'Customers', '/admin/shop/customers', :after => 'Products'
      add_item 'Orders', '/admin/shop/orders', :after => 'Customers'
    end
    
    Page.class_eval { include ShopTags }

    # If our RadiantConfig settings are blank, set them up now
    Radiant::Config['shop.product_layout'] ||= 'Product'
    Radiant::Config['shop.category_layout'] ||= 'Category'
  end
  
end
