class Shop::OrdersController < ApplicationController
  
  no_login_required
  
  def show
    if params[:id] == 'current'
      @shop_order = current_shop_order
    else
      @shop_order = ShopOrder.find(params[:id])
    end
    
    render :text => @shop_order.inspect
  end
  
  
end