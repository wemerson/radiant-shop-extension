# Uncomment this if you reference any of your controllers in activate
require_dependency "#{File.expand_path(File.dirname(__FILE__))}/lib/controller_extensions/application_controller_ext"
require_dependency "#{File.expand_path(File.dirname(__FILE__))}/lib/controller_extensions/site_controller_ext"
require_dependency "#{File.expand_path(File.dirname(__FILE__))}/lib/model_extensions/shop_line_item_ext"
require_dependency "#{File.expand_path(File.dirname(__FILE__))}/lib/model_extensions/shop_order_ext"
class ShopCartExtension < Radiant::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://github.com/crankin/radiant-shop_cart-extension"

  extension_config do |config|
    config.gem 'activemerchant', :version => '~> 1.5.1', :lib => 'active_merchant', :source => 'http://gemcutter.org'
  end

  def activate
    Page.class_eval { include ShopOrderTags }
    
    ApplicationController.send(:include, ShopCart::ApplicationControllerExt)
    SiteController.send(:include, ShopCart::SiteControllerExt)
    ShopOrder.send(:include, ShopCart::ShopOrderExt)
    ShopLineItem.send(:include, ShopCart::ShopLineItemExt)
  end
end
