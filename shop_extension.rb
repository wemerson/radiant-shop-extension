class ShopExtension < Radiant::Extension
  version "0.9"
  description "Core extension for the Radiant shop"
  url "http://github.com/squaretalent/radiant-shop-extension"
  
  extension_config do |config|
    config.gem 'activemerchant',      :version => '1.7.2', :lib => 'active_merchant'
    config.gem 'will_paginate',       :version => '2.3.14'

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
    Page.send :include, Shop::CoreTags, ShopOrderTags
    Image.send :include, Shop::ImageExtensions

    ApplicationController.send(:include, ShopCart::ApplicationControllerExt)
    SiteController.send(:include, ShopCart::SiteControllerExt)
    ShopOrder.send(:include, ShopCart::ShopOrderExt)
    ShopLineItem.send(:include, ShopCart::ShopLineItemExt)
  end
  
end
