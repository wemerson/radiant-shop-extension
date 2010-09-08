require 'spec/spec_helper'

describe Shop::OrdersController do
  before(:each) do
    @shop_order = Object.new
    stub(@shop_order).id { 1 }
  end
  
  describe '#show' do
    before :each do
      mock(controller).find_or_create_shop_order { @shop_order }
    end
    
    it 'should assign the shop order' do
      get :show
      
      assigns(:shop_order) === @shop_order
    end
    
    it 'should assign the title' do
      get :show
      
      assigns(:title).should === 'Your Cart'
    end
    
    context 'html' do
      it 'should render show template' do
        get :show
        
        response.should render_template(:show)
      end
    end
    
    context 'js' do
      it 'should render the order partial' do
        get :show, :format => 'js'
        
        response.should render_template('/shop/orders/_order')
      end
    end
    
    context 'json' do
      it 'should output a json object' do
        get :show, :format => 'json'
        
        response.body.should === @shop_order.to_json(ShopOrder.params)
      end
    end
  end
  
end
