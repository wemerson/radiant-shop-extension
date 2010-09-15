require 'spec/spec_helper'

describe Shop::CategoriesController do
  before(:each) do
    @shop_category = Object.new
    stub(@shop_category).handle { 'a' }
    stub(@shop_category).layout.stub!.name { 'Layout' }
    stub(@shop_category).name { 'Bob' }
    @shop_categories = []
  end
  
  describe 'index' do
    it 'should expose categories list' do
      mock(ShopCategory).search(nil).returns(@shop_categories)
      get :index
      
      response.should be_success
      assigns(:shop_categories).should === @shop_categories
    end
  end
  
  describe '#show' do
    it 'should expose category' do
      mock(ShopCategory).find(:first, :conditions => { :handle => @shop_category.handle}) { @shop_category }
      
      get :show, :handle => @shop_category.handle
      
      response.should be_success
      assigns(:shop_category).should === @shop_category
      assigns(:title).should === 'Bob'
      assigns(:radiant_layout).should === 'Layout'
    end
    
    it 'should return 404 if product empty' do
      mock(ShopCategory).find(:first, :conditions => { :handle => @shop_category.handle}) { false }
      get :show, :handle => @shop_category.handle
      
      response.should render_template('site/not_found')
    end
  end
  
end
