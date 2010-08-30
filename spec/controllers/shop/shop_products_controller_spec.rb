require 'spec/spec_helper'

describe Shop::ProductsController do
  dataset :shop_products
  
  before(:each) do
    @shop_product = shop_products(:soft_bread)
    @shop_products = [shop_products(:soft_bread), shop_products(:crusty_bread), shop_products(:warm_bread)]
  end
  
  describe 'index' do
    it 'should expose products list' do
      mock(ShopProduct).search(nil).returns(@shop_products)
      get :index
      
      response.should be_success
    end
    
    it 'should return 404 if products empty' do
      mock(ShopProduct).search(nil).returns([])
      get :index
      
      response.should render_template('site/not_found')
    end
  end
  
  describe '#show' do
    it 'should expose product' do
      mock(ShopProduct).find.returns(@shop_product)
      get :show
      
      response.should be_success
    end
    
    it 'should return 404 if product empty' do
      mock(ShopProduct).find.returns(nil)
      get :show
      
      response.should render_template('site/not_found')
    end
    
    it 'should find a product by handle' do
      get :show, :handle => @shop_product.handle
      
      response.should be_success
    end
    
    it 'should not find a product with an invalid handle' do
      get :show, :handle => 'i-wont-exist'
      
      response.should render_template('site/not_found')
    end
  end
  
end
