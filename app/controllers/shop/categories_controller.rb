class Shop::CategoriesController < ApplicationController
  
  skip_before_filter :verify_authenticity_token
  no_login_required
  
  radiant_layout Radiant::Config['shop.category_layout']
  
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render :template => 'site/not_found', :status => :unprocessable_entity
  end
  
  def index
    @shop_categories = ShopCategory.search(params[:query])
  end
  
  def show
    @shop_category = ShopCategory.find(:first, :conditions => { :handle => params[:handle] }) || raise(ActiveRecord::RecordNotFound)
    
    @title          = @shop_category.name
    @radiant_layout = @shop_category.layout.name rescue (raise "Couldn't find Layout for Category")
  end

end