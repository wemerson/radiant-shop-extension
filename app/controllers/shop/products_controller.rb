class Shop::ProductsController < ApplicationController
  
  skip_before_filter :verify_authenticity_token
  no_login_required
  
  radiant_layout Radiant::Config['shop.product_layout']

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render :template => 'site/not_found', :status => :unprocessable_entity
  end
  
  # GET /shop/search/:query
  # GET /shop/search/:query.js
  # GET /shop/search/:query.json                                  AJAX and HTML
  #----------------------------------------------------------------------------
  def index
    @shop_products = ShopProduct.search(params[:query])
    @radiant_layout = Radiant::Config['shop.category_layout']
    
    respond_to do |format|
      format.html { render }
      format.js   { render :partial => '/shop/products/index/product', :collection => @shop_products }
      format.json { render :json    => @shop_products.to_json(ShopProduct.params) }
    end
  end
  
  # GET /shop/:category_handle/:handle
  # GET /shop/:category_handle/:handle.js
  # GET /shop/:category_handle/:handle.json                       AJAX and HTML
  #----------------------------------------------------------------------------
  def show
    if @shop_product = ShopProduct.find(:first, :conditions => { :sku => params[:sku] })
      @shop_category = @shop_product.category unless @shop_product.nil?
    
      @radiant_layout = @shop_product.layout.name
      @title = @shop_product.name
    
      respond_to do |format|
        format.html { render }
        format.js   { render :partial => '/shop/products/index/product', :locals => { :product => @shop_product } }
        format.json { render :json => @shop_product.to_json(ShopProduct.params) }
      end
    else
      raise ActiveRecord::RecordNotFound
    end
  end
  
end
