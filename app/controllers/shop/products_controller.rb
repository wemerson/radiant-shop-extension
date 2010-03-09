class Shop::ProductsController < ApplicationController
	radiant_layout 'Product'
  no_login_required

	def show
		@product=ShopProduct.find_by_name(params[:name].gsub('_', ' '), :include => :category)
		@title = @product.title
		
		@radiant_layout=@product.layout
	end
end
