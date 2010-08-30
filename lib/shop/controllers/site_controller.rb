module Shop
  module Controllers
    module SiteController
      
      def self.included(base)
        base.class_eval do
          before_filter :initialize_shop_order
        end
        base.send :include, InstanceMethods
      end
      
      module InstanceMethods
        def initialize_shop_order
          if request.session[:shop_order]
            @order = ShopOrder.find(request.session[:shop_order])
          else
            @order = ShopOrder.create
            request.session[:shop_order] = @order.id
          end
        end
      end
      
    end
  end
end