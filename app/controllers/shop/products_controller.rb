class Shop::ProductsController < ApplicationController
  #radiant_layout 'Product'
  no_login_required
  before_filter :initialize_cart

  def show
    @shop_product = ShopProduct.find(:first, {:conditions => ['LOWER(handle) = ?', params[:handle]], :include => :category})
    @title = @shop_product.title
    
    @radiant_layout=@shop_product.layout
  end

end
