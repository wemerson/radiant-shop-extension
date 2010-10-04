require 'spec/spec_helper'

describe Shop::CategoriesController do

  dataset :shop_categories
  
  describe 'index' do
    context 'no query' do
      it 'should expose categories list' do
        get :index
      
        response.should be_success
        assigns(:shop_categories).should === ShopCategory.all
      end
    end
    
    context 'query' do
      before :each do
        @category = shop_categories(:bread)
      end
      it 'should expose a subgroup' do
        get :index, :query => @category.handle
        
        response.should be_success
        assigns(:shop_categories).should === ShopCategory.search(@category.handle)
      end
    end
  end
  
  describe '#show' do
    context 'category exists' do
      it 'should expose category' do
        @category = shop_categories(:bread)
      
        get :show, :handle => @category.handle
      
        response.should be_success
        assigns(:shop_category).should  === @category
        assigns(:title).should          === @category.name
        assigns(:radiant_layout).should === @category.layout.name
      end
    end
    
    context 'category does not exist' do
      it 'should return 404' do
        get :show, :handle => 'does not exist'
      
        response.should render_template('site/not_found')
      end
    end
  end
  
end
