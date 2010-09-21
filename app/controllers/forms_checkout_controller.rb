class FormsCheckoutController
  include Forms::Controllers::Extensions
  
  def create
    raise @page.request.inspect
    
    @order = ShopOrder.find(@page.request.session[:shop_order])
    
    raise @order.inspect
    
  end
    
end