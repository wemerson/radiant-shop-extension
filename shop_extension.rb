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
  UserActionObserver.instance.send :add_observer!, ShopGroup
  UserActionObserver.instance.send :add_observer!, ShopProductAttachment
  UserActionObserver.instance.send :add_observer!, ShopProductVariant
  UserActionObserver.instance.send :add_observer!, ShopVariant
  
  def activate    
    # View Hooks
    unless defined? admin.products
      Radiant::AdminUI.send :include, Shop::Interface::Products, Shop::Interface::Customers, Shop::Interface::Orders, Shop::Interface::Variants, Shop::Interface::Groups
      
      admin.products  = Radiant::AdminUI.load_default_shop_products_regions
      admin.categories= Radiant::AdminUI.load_default_shop_categories_regions
      admin.customers = Radiant::AdminUI.load_default_shop_customers_regions
      admin.orders    = Radiant::AdminUI.load_default_shop_orders_regions
      admin.variants  = Radiant::AdminUI.load_default_shop_variants_regions
      admin.groups    = Radiant::AdminUI.load_default_shop_groups_regions
    end
    
    if admin.respond_to? :page
      admin.page.edit.add :layout_row, 'shop_category'
      admin.page.edit.add :layout_row, 'shop_product' 
    end
    
    # Tags
    Page.send :include, Shop::Tags::Core, Shop::Tags::Cart, Shop::Tags::Category, Shop::Tags::Item, Shop::Tags::Product, Shop::Tags::Address, Shop::Tags::Responses, Shop::Tags::Card
    
    # Model Includes
    Page.send :include, Shop::Models::Page
    Image.send :include, Shop::Models::Image
    
    # Controller Includes
    ApplicationController.send :include, Shop::Controllers::ApplicationController
    SiteController.send :include, Shop::Controllers::SiteController
    
    # Tabs3
    
    tab "Shop" do
      add_item "Products",  "/admin/shop"
      add_item "Variants",  "/admin/shop/variants"
      add_item "Groups",    "/admin/shop/groups"
      add_item "Orders",    "/admin/shop/orders"
      add_item "Customers", "/admin/shop/customers"
    end
    
    # Ensure there is always a shop prefix, otherwise we'll lose admin and pages
    Radiant::Config['shop.url_prefix'] = Radiant::Config['shop.url_prefix'].blank? ? 'shop' : Radiant::Config['shop.url_prefix']
    Radiant::Config['shop.product_layout']  ||= 'Product'
    Radiant::Config['shop.category_layout'] ||= 'Products'
    Radiant::Config['shop.order_layout']    ||= 'Cart'
    
    Radiant::Config['shop.cart_thanks_path']||= 'cart/thanks'
    Radiant::Config['shop.cart_path']       ||= 'cart'
    
    Radiant::Config['shop.price_unit']      ||= '$'
    Radiant::Config['shop.price_precision'] ||= 2
    Radiant::Config['shop.price_seperator'] ||= '.'
    Radiant::Config['shop.price_delimiter'] ||= ','
    
    # Scoped Customer Welcome Page
    Radiant::Config['scoped.customer.redirect'] = '/cart'
  end
  
end
