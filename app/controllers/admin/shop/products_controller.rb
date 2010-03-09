class Admin::Shop::ProductsController < Admin::ResourceController
	model_class ShopProduct
	helper :shop
	
	def index
	  @shop_categories = ShopCategory.search(params[:search], params[:filter], params[:page])
	  
	  respond_to do |format|
      format.html { render }
      format.js {
        render :partial => 'products_table', :categories => @shop_categories, :layout => false
      }
    end
  end
  
  def new
    @shop_product = ShopProduct.new
    @shop_product.category = ShopCategory.find(params[:category])
  end
  
end
