class FormsCheckoutController < ApplicationController
  include Forms::Controllers::Extensions
  
  def create
    order = current_shop_order
    
    order.checkout
    
    result = {
      :paid     => order.paid?,
    }
  end
    
end