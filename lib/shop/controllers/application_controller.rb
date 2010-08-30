module Shop
  module Controllers
    module ApplicationController
      
      def self.included(base)
        base.class_eval do
          helper_method :current_shop_order
        end
        base.send :include, InstanceMethods
      end
      
      module InstanceMethods
        def current_shop_order
          @order = ShopOrder.find(request.session[:shop_order])
        end
      end
      
    end
  end
end