class Shop::OrdersController < ApplicationController
  
  no_login_required
  
  def index
    render :text => ShopOrder.find(session[:shop_order]).inspect
  end
  
  
end