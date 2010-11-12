class ShopExtension < Radiant::Extension
  version YAML::load_file(File.join(File.dirname(__FILE__), 'VERSION'))
  description "Core extension for the Radiant shop"
  url "http://github.com/dirkkelly/radiant-shop-extension"
  
  extension_config do |config|
    config.gem 'activemerchant',              :lib => 'active_merchant'
    config.gem 'fastercsv',                   :lib => 'fastercsv'
    config.gem 'radiant-settings-extension',  :lib => false
    config.gem 'radiant-users-extension',     :lib => false
    config.gem 'radiant-images-extension',    :lib => false
    config.gem 'radiant-forms-extension',     :lib => false
    config.gem 'radiant-drag-extension',      :lib => false
  end
  
  UserActionObserver.instance.send :add_observer!, ShopCategory
  UserActionObserver.instance.send :add_observer!, ShopOrder
  UserActionObserver.instance.send :add_observer!, ShopProduct
  UserActionObserver.instance.send :add_observer!, ShopProductAttachment
  
  def activate
    require 'shop/activate/config'
    require 'shop/activate/interface'
    require 'shop/activate/tags'
    require 'shop/activate/models'
    require 'shop/activate/controllers'
  end
  
end
