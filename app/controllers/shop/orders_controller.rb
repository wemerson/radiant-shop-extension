class Shop::OrdersController < ApplicationController
  no_login_required
  skip_before_filter :verify_authenticity_token
  
  def show
    if params[:id] == 'current'
      @shop_order = current_shop_order
    else
      @shop_order = ShopOrder.find(params[:id])
    end
  end
  
  
end