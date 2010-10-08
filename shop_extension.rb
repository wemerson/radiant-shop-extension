class ShopExtension < Radiant::Extension
  version "0.9"
  description "Core extension for the Radiant shop"
  url "http://github.com/squaretalent/radiant-shop-extension"
  
  extension_config do |config|
    config.gem 'activemerchant',            :version => '1.7.3',    :lib => 'active_merchant'
    config.gem 'will_paginate',             :version => '2.3.14'
  end
  
  UserActionObserver.instance.send :add_observer!, ShopProduct
  UserActionObserver.instance.send :add_observer!, ShopCategory
  UserActionObserver.instance.send :add_observer!, ShopOrder
  UserActionObserver.instance.send :add_observer!, ShopProductAttachment
  UserActionObserver.instance.send :add_observer!, ShopProductVariant
  UserActionObserver.instance.send :add_observer!, ShopVariant
  UserActionObserver.instance.send :add_observer!, ShopPackage
  
  def activate    
    # View Hooks
    unless defined? admin.products
      Radiant::AdminUI.send :include, Shop::Interface::Categories, Shop::Interface::Customers, Shop::Interface::Orders, Shop::Interface::Packages, Shop::Interface::Products, Shop::Interface::Variants

      admin.categories= Radiant::AdminUI.load_default_shop_categories_regions
      admin.customers = Radiant::AdminUI.load_default_shop_customers_regions
      admin.orders    = Radiant::AdminUI.load_default_shop_orders_regions
      admin.packages  = Radiant::AdminUI.load_default_shop_packages_regions      
      admin.products  = Radiant::AdminUI.load_default_shop_products_regions
      admin.variants  = Radiant::AdminUI.load_default_shop_variants_regions
    end
    
    # if admin.respond_to? :page
    #   admin.page.edit.add :layout_row, 'shop_category'
    #   admin.page.edit.add :layout_row, 'shop_product' 
    # end
    
    # Tags
    Page.send :include, Shop::Tags::Core, Shop::Tags::Address, Shop::Tags::Card, Shop::Tags::Cart, Shop::Tags::Category, Shop::Tags::Item, Shop::Tags::Package, Shop::Tags::Product, Shop::Tags::ProductVariant, Shop::Tags::Responses
    
    # Model Includes
    Page.send :include, Shop::Models::Page
    Image.send :include, Shop::Models::Image
    
    # Controller Includes
    ApplicationController.send :include, Shop::Controllers::ApplicationController
    SiteController.send :include, Shop::Controllers::SiteController
    
    # Tabs3
    
    tab "Shop" do
      add_item "Products",      "/admin/shop"
      add_item "Orders",        "/admin/shop/orders"
      add_item "Customers",     "/admin/shop/customers"
    end
    
    Radiant::Config['shop.root_page_id']    ||= (Page.first(:conditions => { :slug => 'shop'}).id rescue (Page.first.id rescue nil))
    Radiant::Config['shop.root_page_slug']  ||= 'shop'
    
    Radiant::Config['shop.layout_product']  ||= 'Product'
    Radiant::Config['shop.layout_category'] ||= 'Products'
    
    Radiant::Config['shop.price_unit']      ||= '$'
    Radiant::Config['shop.price_precision'] ||= 2
    Radiant::Config['shop.price_separator'] ||= '.'
    Radiant::Config['shop.price_delimiter'] ||= ','
    
    # Scoped Customer Welcome Page
    Radiant::Config['scoped.customer.redirect'] = '/cart'
  end
  
end
