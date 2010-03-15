class Shop::CategoriesController < ApplicationController
  radiant_layout 'Category'
  no_login_required

  def show
    @shop_category=ShopCategory.find(:first, :conditions => ['LOWER(title) = ?', params[:title].downcase.gsub('_', ' ')])
    @title = @shop_category.title

    @radiant_layout=@shop_category.layout
  end
end