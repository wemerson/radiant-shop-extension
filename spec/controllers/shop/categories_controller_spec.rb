require 'spec/spec_helper'

describe Shop::CategoriesController do
  before(:each) do
    @shop_category = Object.new
    stub(@shop_category).handle { 'a' }
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
      mock(@shop_category).layout
      mock(@shop_category).name
      mock(ShopCategory).find_by_handle(@shop_category.handle) { @shop_category }
      
      get :show, :handle => @shop_category.handle
      
      response.should be_success
      assigns(:shop_category).should === @shop_category
    end
    
    it 'should return 404 if product empty' do
      mock(ShopCategory).find_by_handle(@shop_category.handle) { raise ActiveRecord::RecordNotFound }
      get :show, :handle => @shop_category.handle
      
      response.should render_template('site/not_found')
    end
  end
  
end
