require 'spec/spec_helper'

describe Shop::ProductsController do
  before(:each) do
    @shop_product = Object.new
    stub(@shop_product).handle.returns(rand)
    stub(@shop_product).category.stub!.handle.returns(rand)
    @shop_products = []
  end
  
  describe 'index' do
    it 'should expose products list' do
      mock(ShopProduct).search(nil).returns(@shop_products)
      get :index
      
      response.should be_success
      assigns(:shop_products).should === @shop_products
    end
  end
  
  describe '#show' do
    it 'should expose product' do
      mock(@shop_product).layout
      mock(@shop_product).name
      mock(ShopProduct).find_by_handle(@shop_product.handle).returns(@shop_product)

      get :show, :handle => @shop_product.handle, :category_handle => @shop_product.category.handle
      
      response.should be_success
      assigns(:shop_product).should === @shop_product
      assigns(:shop_category).should == @shop_product.category
    end
    
    it 'should return 404 if product empty' do
      mock(ShopProduct).find_by_handle(@shop_product.handle) { raise ActiveRecord::RecordNotFound }

      get :show, :handle => @shop_product.handle, :category_handle => @shop_product.category.handle
      
      response.should render_template('site/not_found')
    end
  end
  
end
