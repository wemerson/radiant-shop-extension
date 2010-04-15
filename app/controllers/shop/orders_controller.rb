class Shop::OrdersController < ApplicationController
  radiant_layout 'ShopCart'
  no_login_required
  
  def show
    if params[:id] == 'current'
      @shop_order = current_shop_order
    else
      @shop_order=ShopOrder.find(params[:id])
    end
    
    if @shop_order
      @title = @shop_order.id

      respond_to do |format|
        format.html { render }
        format.js { render :partial => '/shop/orders/order', :locals => { :order => @shop_order } }
        format.xml { render :xml => @shop_order.to_xml(attr_hash) }
        format.json { render :json => @shop_order.to_json(attr_hash) }
      end
    else
      render :template => 'site/not_found', :status => 404
    end
    
  end
  
end