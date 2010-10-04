class Shop::ProductsController < ApplicationController
  
  skip_before_filter :verify_authenticity_token
  no_login_required
  
  radiant_layout Radiant::Config['shop.product_layout']

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render :template => 'site/not_found', :status => :unprocessable_entity
  end
  
  def index
    @shop_products  = ShopProduct.search(params[:query])
    @radiant_layout = Radiant::Config['shop.category_layout']
  end
  
  def show
    @shop_product   = ShopProduct.find(:first, :conditions => { :sku => params[:sku] }) || raise(ActiveRecord::RecordNotFound)
    
    @radiant_layout = @shop_product.layout.name rescue (raise "Couldn't find Layout for Product")
    @title = @shop_product.name
  end
  
end