module Shop
  module Controllers
    module ApplicationController
      
      def self.included(base)
        base.class_eval do
          filter_parameter_logging :password, :password_confirmation, :credit
          
          def current_shop_order
            find_or_create_shop_order
          end
          
          def find_shop_order
            begin
              ShopOrder.find_by_session(request.session[:shop_order])
            rescue
              nil
            end
          end
          
          def find_or_create_shop_order
            if find_shop_order
              return find_shop_order
            else
              if current_customer
                shop_order = ShopOrder.create(:customer_id => (current_user.id))
              else
                shop_order = ShopOrder.create
              end
              request.session[:shop_order] = shop_order.id
              return shop_order
            end
          end
        end
      end
      
    end
  end
end