module Shop
  module Activate
    module Interface
  
      def self.included(base)
        base.class_eval do
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
      end
  
    end
  end
end