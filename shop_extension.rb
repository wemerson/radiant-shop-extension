class ShopExtension < Radiant::Extension
  version YAML::load_file(File.join(File.dirname(__FILE__), 'VERSION'))
  description "Radiant Shop provides"
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
    tab "Shop" do
      add_item "Products",  "/admin/shop"
      add_item "Orders",    "/admin/shop/orders"
      add_item "Customers", "/admin/shop/customers"
    end
    
    unless defined? admin.products
      Radiant::AdminUI.send :include, Shop::Interface::Categories, Shop::Interface::Customers
      Radiant::AdminUI.send :include, Shop::Interface::Discounts,  Shop::Interface::Orders,    Shop::Interface::Products
      
      admin.categories = Radiant::AdminUI.load_default_shop_categories_regions
      admin.customers  = Radiant::AdminUI.load_default_shop_customers_regions
      admin.discounts  = Radiant::AdminUI.load_default_shop_discounts_regions
      admin.orders     = Radiant::AdminUI.load_default_shop_orders_regions 
      admin.products   = Radiant::AdminUI.load_default_shop_products_regions
    end
  end
  
  require 'shop/activate/config'
  require 'shop/activate/tags'
  require 'shop/activate/models'
  require 'shop/activate/controllers'
  
end
