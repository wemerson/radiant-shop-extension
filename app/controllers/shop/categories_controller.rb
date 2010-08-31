class Shop::CategoriesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  no_login_required
  
  radiant_layout Radiant::Config['shop.product_layout']

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render :template => 'site/not_found', :status => 404
  end
  
  # GET /shop/categories/:query
  # GET /shop/categories/:query.js
  # GET /shop/categories/:query.xml
  # GET /shop/categories/:query.json                              AJAX and HTML
  #----------------------------------------------------------------------------
  def index
    @shop_categories = ShopCategory.search(params[:query])
    @radiant_layout = Radiant::Config['shop.category_layout']
    
    respond_to do |format|
      format.html { render }
      format.js { render :partial => '/shop/categories/categories', :collection => @shop_categories }
      format.xml { render :xml => @shop_categories.to_xml(attr_hash) }
      format.json { render :json => @shop_categories.to_json(attr_hash) }
    end
  end
  
  # GET /shop/:handle
  # GET /shop/:handle.js
  # GET /shop/:handle.xml
  # GET /shop/:handle.json                                        AJAX and HTML
  #----------------------------------------------------------------------------
  def show
    @shop_category = ShopCategory.find_by_handle(params[:handle])
    
    attr_hash =  {
      :include => :products,
      :except => [:json_field]
    }
    
    @title = @shop_category.name
    @radiant_layout = @shop_category.layout
    
    respond_to do |format|
      format.html { render }
      format.js { render :partial => '/shop/categories/category', :locals => { :category => @shop_category } }
      format.xml { render :xml => @shop_category.to_xml(attr_hash) }
      format.json { render :json => @shop_category.to_json(attr_hash) }
    end
    
  end

end
