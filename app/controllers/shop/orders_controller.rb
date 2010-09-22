class Shop::OrdersController < ApplicationController
  
  no_login_required
  
  def finalize
    @order = current_shop_order
    
    if @order.present? and !@order.new?
      request.session[:shop_order] = nil
      redirect_to "/#{Radiant::Config['shop.cart_thanks_path']}"
    else
      redirect_to "/#{Radiant::Config['shop.cart_path']}"
    end
  end

end