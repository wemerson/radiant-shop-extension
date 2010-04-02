class Shop::ProductsController < ApplicationController
  no_login_required
  before_filter :initialize_cart
  
  def show
    @shop_product=ShopProduct.find(:first, :conditions => ['LOWER(handle) = ?', params[:handle]])
    
    @title = @shop_product.title
    @radiant_layout=@shop_product.layout
    
    respond_to do |format|
      format.html { render }
      format.js { render :partial => '/shop/products/product', :locals => { :product => @shop_product } }
      format.xml { render :xml => @shop_product.to_xml(attr_hash) }
      format.json { render :json => @shop_product.to_json(attr_hash) }
    end
    
  end
end