require_dependency 'application_controller'
require_dependency "#{File.expand_path(File.dirname(__FILE__))}/lib/page_extensions_for_shop_category"
require 'ostruct'

class ShopExtension < Radiant::Extension
  version "0.7"
  description "Core extension for the Radiant shop"
  url "http://github.com/squaretalent/radiant-shop-extension"
  
  define_routes do |map|
    #allows us to pass category to a product
    map.namespace :admin, :member => {:remove => :get} do |admin|
      admin.namespace :shop, :member => {:remove => :get} do |shop|
        shop.connect 'products/categories/:id/products.:format', :controller => 'categories', :action => 'products', :conditions => { :method => :get }
        shop.resources :categories, :as => 'products/categories'
        shop.resources :products
        shop.resources :customers
        shop.resources :orders
      end
    end
  end
  
  extension_config do |config|
    config.gem 'will_paginate', :version => '~> 2.3.11', :source => 'http://gemcutter.org'
  end
  
  def activate  
    Page.class_eval { include ShopTags }
<<<<<<< HEAD

    # If our RadiantConfig settings are blank, set them up now
    Radiant::Config['shop.product_layout'] ||= 'Product'
    Radiant::Config['shop.category_layout'] ||= 'Category'
=======
>>>>>>> 1447562bb3828fc9ef0fb5b2beb2cd74784d8704
  end
  
end
