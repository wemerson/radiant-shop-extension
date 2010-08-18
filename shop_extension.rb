class ShopExtension < Radiant::Extension
  version "0.7"
  description "Core extension for the Radiant shop"
  url "http://github.com/squaretalent/radiant-shop-extension"
  
  extension_config do |config|
    config.gem 'will_paginate', :version => '~> 2.3.11', :source => 'http://gemcutter.org'
    config.gem 'rr', :version => '~> 0.10.10', :source => 'http://gemcutter.org'
  end
  
  UserActionObserver.instance.send :add_observer!, ShopProduct
  UserActionObserver.instance.send :add_observer!, ShopCategory
  UserActionObserver.instance.send :add_observer!, ShopOrder
  
  def activate  
    Page.send :include, Shop::CoreTags
    Image.send :include, Shop::ImageExtensions
  end
  
end
