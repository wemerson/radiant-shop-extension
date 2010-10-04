require 'spec/spec_helper'

describe Shop::ProductsController do

  dataset :shop_products
  
  describe 'index' do
    context 'no query' do
      it 'should expose products list' do
        get :index
        
        response.should be_success
        assigns(:shop_products).should  === ShopProduct.all
        assigns(:radiant_layout).should === Radiant::Config['shop.category_layout']
      end
    end
    
    context 'query' do
      before :each do
        @product = shop_products(:crusty_bread)
      end
      it 'should expose a subgroup' do
        get :index, :query => @product.sku
        
        response.should be_success        
        assigns(:shop_products).should === ShopProduct.search(@product.sku)
      end
    end
  end
  
  describe '#show' do
    before :each do
      @product = shop_products(:crusty_bread)
    end
    context 'product exists' do
      it 'should expose product' do
        get :show, :handle => @product.category.handle, :sku => @product.sku
        
        response.should be_success
        assigns(:shop_product).should   === @product
        assigns(:title).should          === @product.name
        assigns(:radiant_layout).should === @product.layout.name
      end
    end
    
    context 'product does not exist' do
      it 'should return 404' do
        get :show, :handle => @product.category.handle, :sku => 'does not exist'
      
        response.should render_template('site/not_found')
      end
    end
    
    context 'incorrect category for product' do
      it 'should expose product' do
        get :show, :handle => 'does not exist', :sku => @product.sku
        
        response.should be_success
        assigns(:shop_product).should   === @product
        assigns(:title).should          === @product.name
        assigns(:radiant_layout).should === @product.layout.name
      end
    end
  end
  
end
