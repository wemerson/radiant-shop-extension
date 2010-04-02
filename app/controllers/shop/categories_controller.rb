class Shop::CategoriesController < ApplicationController
  radiant_layout 'ShopCategory'
  no_login_required
  
  def show
    @shop_category=ShopCategory.find(:first, :conditions => ['LOWER(handle) = ?', params[:handle]])
    attr_hash =  {
      :include => :products,
      :except => [:json_field]
    }
    
    @title = @shop_category.title
    @radiant_layout=@shop_category.layout
    
    respond_to do |format|
      format.html { render }
      format.js { render :partial => '/shop/categories/category', :locals => { :category => @shop_category } }
      format.xml { render :xml => @shop_category.to_xml(attr_hash) }
      format.json { render :json => @shop_category.to_json(attr_hash) }
    end
    
  end
end