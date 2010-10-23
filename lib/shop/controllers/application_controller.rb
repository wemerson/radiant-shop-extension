module Shop
  module Controllers
    module ApplicationController
      
      def self.included(base)
        base.class_eval do
          def current_shop_order
            return @current_shop_order if defined?(@current_shop_order)
            @current_shop_order = find_or_create_shop_order if request.session[:shop_order]
          end
          
          def find_shop_order
            shop_order = nil
            
            begin
              shop_order = ShopOrder.find(request.session[:shop_order])
            rescue
              shop_order = nil
            end
                        
            shop_order
          end
          
          def find_or_create_shop_order
            shop_order = nil
            
            if find_shop_order and find_shop_order.status != 'paid'
              shop_order = find_shop_order
            else
              shop_order = ShopOrder.create({ :customer_id => (current_user.id rescue nil) })
              request.session[:shop_order] = shop_order.id
            end
            
            shop_order
          end
        end
      end
      
    end
  end
end