module Shop
  module Controllers
    module ApplicationController
      
      def self.included(base)
        base.class_eval do
          def current_shop_order            
            return @current_shop_order if defined?(@current_shop_order)
            @current_shop_order = find_shop_order
          end
          
          def find_shop_order
            shop_order = nil
            
            if request.session[:shop_order]
              shop_order = ShopOrder.find(request.session[:shop_order])
            end
            
            shop_order
          end
          
          def find_or_create_shop_order
            shop_order = nil
            
            if find_shop_order
              shop_order = find_shop_order
            else
              shop_order = ShopOrder.create
              request.session[:shop_order] = shop_order.id
            end
            
            shop_order
          end
        end
      end
      
    end
  end
end