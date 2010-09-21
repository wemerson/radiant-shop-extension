require 'spec/spec_helper'

describe FormsCheckoutController do
  
  dataset :users, :shop_orders, :forms, :pages
  
  before :each do
    login_as :admin
  end
  
  describe '#create' do
    
    it 'should assign the order from current_order' do
      @order = shop_orders(:one_item)
      @page  = pages(:home)
      @form  = forms(:checkout)
      
      form = FormsCheckoutController.new(@form, @page)
      
      post :create
      
      assigns(:order).should === @order
    end
    
  end
  
end
