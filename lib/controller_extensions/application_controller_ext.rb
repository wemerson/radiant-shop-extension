module ShopCart
  module ApplicationControllerExt
    def self.included(base)
      base.class_eval {
        helper_method :current_shop_order       
        
        def current_shop_order
          @order = ShopOrder.find(request.session[:shop_order])
        end
      }
    end
  end
end