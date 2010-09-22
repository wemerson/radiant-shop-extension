require 'spec/spec_helper'

describe Shop::OrdersController do
  
  dataset :shop_orders
  
  before(:each) do
    @order = shop_orders(:one_item)
  end
  
  describe '#finalize' do
    context 'paid order' do
      it 'should redirect to the thanks page' do
        stub(@order).new? { false }
        mock(controller).current_shop_order { @order }
        
        get :finalize
        
        response.should redirect_to("/#{Radiant::Config['shop.cart_thanks_path']}")
      end
    end
    
    context 'new order' do
      it 'should redirect to the cart page' do
        stub(@order).new? { true }
        mock(controller).current_shop_order { @order }
        
        get :finalize
        
        response.should redirect_to("/#{Radiant::Config['shop.cart_path']}")
      end
    end
  end

end