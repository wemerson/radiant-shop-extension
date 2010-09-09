class Shop::OrdersController < ApplicationController
  
  no_login_required
  
  radiant_layout Radiant::Config['shop.order_layout']
  
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render :template => 'site/not_found', :status => :unprocessable_entity
  end  
  
  # GET /shop/cart
  # GET /shop/cart.js
  # GET /shop/cart.json                                           AJAX and HTML
  #----------------------------------------------------------------------------
  def show
    attr_hash = ShopOrder.params
    
    @shop_order = find_or_create_shop_order
    @title = "Your Cart"
    
    respond_to do |format|
      format.html   { render :show }
      format.js     { render :partial => '/shop/orders/order', :locals => { :order => @shop_order } }
      format.json   { render :json    => @shop_order.to_json(attr_hash) }
    end
    
  end
  
end