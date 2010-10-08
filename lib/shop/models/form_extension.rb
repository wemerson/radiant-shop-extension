module Shop
  module Models
    module FormExtension
      
      def self.included(base)
        base.class_eval do
          # Uses the page session data to find the current order
          def find_current_order
            @order  = ShopOrder.find(@page.request.session[:shop_order])
            @order.update_attribute(:customer_id, (current_customer.id rescue nil)) # either assign it to a user, or don't
          end

          # Returns the current logged in ShopCustomer (if it exists)
          def current_customer
            return @shop_customer if @shop_customer.present?
            return current_user if current_user.present?
            @shop_customer = ShopCustomer.find(current_user.id)
          end
        end
      end
    end
  end
end