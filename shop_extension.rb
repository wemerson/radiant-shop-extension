require_dependency 'application_controller'
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
  end
  
end
