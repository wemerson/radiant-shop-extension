class FormsCheckoutController < ApplicationController
  include Forms::Controllers::Extensions
  
  def create
    @order = current_shop_order
    
    checkout = FormCheckout.new(@form, @page, @order)
    
    checkout.process
    
    result = {
      :checkout => {
        :success => checkout.success?,
        :message => checkout.message
      } 
    }
    
  end
    
end