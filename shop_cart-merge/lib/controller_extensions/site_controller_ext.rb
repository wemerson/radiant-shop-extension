module ShopCart
  module SiteControllerExt
    def self.included(base)
      base.class_eval {
        before_filter :initialize_shop_order
        
        def initialize_shop_order
          if request.session[:shop_order]
            @order = ShopOrder.find(request.session[:shop_order])
          else
            @order = ShopOrder.create(:status => 'new')
            request.session[:shop_order] = @order.id
          end
        end
      }
    end
  end
end