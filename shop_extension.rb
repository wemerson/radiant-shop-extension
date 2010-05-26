require_dependency "#{File.expand_path(File.dirname(__FILE__))}/lib/asset_shop_product_images_associations"

require_dependency 'application_controller'
require 'ostruct'

class ShopExtension < Radiant::Extension
  version "0.7"
  description "Core extension for the Radiant shop"
  url "http://github.com/squaretalent/radiant-shop-extension"
  
  define_routes do |map|
    #allows us to pass category to a product
    map.namespace :admin, :member => {:remove => :get} do |admin|
      admin.namespace :shop do |shop|
        shop.namespace :products do |products|
          products.resources :images
          products.resources :assets
        end
        
        shop.resources :categories do |category|
          category.new_product 'products/new.:format', :controller => 'products', :action => 'new', :conditions => { :method => :get }
          category.products 'products.:format', :controller => 'categories', :action => 'products', :conditions => { :method => :get }
        end
        shop.resources :products do |product|
          product.resources :assets, :controller => 'products/assets', :only => [ :index, :show, :create ]
          product.images_sort 'images/sort.:format', :controller => 'products/images', :action => 'sort', :conditions => { :method => :put }
          product.resources :images, :controller => 'products/images', :only => [ :index, :create, :show, :destroy ]
        end
        shop.resources :customers
        shop.resources :orders
      end
    end
  end
  
  extension_config do |config|
    config.gem 'will_paginate', :version => '~> 2.3.11', :source => 'http://gemcutter.org'
    #config.gem 'radiant-paperclipped-extension'
  end
  
  def activate  
    Page.class_eval { include ShopTags }
    
    Asset.class_eval { include AssetShopProductImagesAssociations } #Product Images uses paperclipped
  end
  
end
