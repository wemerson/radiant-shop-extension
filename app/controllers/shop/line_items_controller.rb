class Shop::LineItemsController < ApplicationController
  
  no_login_required
  
  skip_before_filter :verify_authenticity_token  
  
  def create
    current_shop_order.line_items.create(params[:line_item])
    redirect_to :back
  end
  
  
end