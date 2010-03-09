class Shop::CategoriesController < ApplicationController
	radiant_layout 'Category'
  no_login_required
  
	def show
		@category=ShopCategory.find_by_name(params[:name].gsub('_', ' '))
		@title = @category.title

		@radiant_layout=@category.layout
	end
end
