class Shop::ProductsController < ApplicationController
	radiant_layout 'Product'
  no_login_required

	def show
	  @shop_product=ShopProduct.find(:first, {:conditions => ['LOWER(title) = ?', params[:title].downcase.gsub('_', ' ')], :include => :category})
		@title = @shop_product.title
		@radiant_layout=@shop_product.layout
	end
end
