class Admin::Shop::CategoriesController < Admin::ResourceController
	model_class ShopCategory
	helper :shop
	
	def index
	  redirect_to admin_shop_products_path
  end
  
end
