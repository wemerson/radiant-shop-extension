require 'spec/spec_helper'

describe Shop::ProductsController do
  before(:each) do
    @shop_product = ShopProduct.new
    @shop_category = ShopCategory.new
    
    stub(@shop_product).sku { 'a' }
    stub(@shop_product).name { 'Bob' }
    stub(@shop_product).category { @shop_category }
    
    stub(@shop_category).handle { 'b' }
    stub(@shop_category).product_layout.stub!.name { 'Layout' }
    
    @shop_products = [ @shop_product ]
  end
  
  describe '#index' do
    it 'should expose products list' do
      mock(ShopProduct).search(nil) { @shop_products }
      get :index
      
      response.should be_success
      assigns(:shop_products).should === @shop_products
    end
  end
  
  describe '#show' do
    it 'should expose product' do
      mock(ShopProduct).find(:first, :conditions => { :sku => @shop_product.sku }) { @shop_product }
      
      get :show, :sku => @shop_product.sku, :handle => @shop_category.handle
      
      response.should be_success
      assigns(:shop_product).should === @shop_product
      assigns(:shop_category).should == @shop_product.category
      assigns(:radiant_layout).should == 'Layout'
      assigns(:title).should === 'Bob'
    end
    
    it 'should return 404 if product empty' do
      mock(ShopProduct).find(:first, :conditions => { :sku => @shop_product.sku }) { false }
      
      get :show, :sku => @shop_product.sku, :handle => @shop_category.handle
            
      response.should render_template('site/not_found')
      response.should_not be_success
    end
  end
  
end
