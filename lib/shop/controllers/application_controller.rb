module Shop
  module Controllers
    module ApplicationController
      
      def self.included(base)
        base.send :include, InstanceMethods
      end
      
      module InstanceMethods
        
        def current_shop_order
          return @current_shop_order if defined?(@current_shop_order)
          @current_shop_order = initialize_shop_order 
        end
        
        def initialize_shop_order
          begin
            shop_order = ShopOrder.find(request.session[:shop_order])
          rescue
            shop_order = ShopOrder.create
            request.session[:shop_order] = @order.id
          end
          
          shop_order
        end
      end
      
    end
  end
end