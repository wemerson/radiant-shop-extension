module Shop
  module Models
    module FormExtension
      
      def self.included(base)
        base.class_eval do
          # Uses the page session data to find the current order
          def find_current_order
            @order  = ShopOrder.find(@page.request.session[:shop_order])
            if current_customer
              @order.update_attribute(:customer_id, (current_customer.id))
            end
          end
          
          # Uses the page session data to find or create the current order
          def find_or_create_current_order
            begin
              find_current_order
            rescue
              @order = ShopOrder.create
              @result[:session] = { :shop_order => @order.id }
              if current_customer
                @order.update_attribute(:customer_id, (current_customer.id))
              end
            end
          end
          
          # Returns the current logged in ShopCustomer (if it exists)
          def current_customer
            return @shop_customer if @shop_customer.present?
            @shop_customer = current_user if current_user.present?
          end
        end
      end
    end
  end
end