require 'spec/spec_helper'

describe Admin::Shop::ProductsController do
  
  before :all do
    @attr_hash = {
      :include  => { :category => { :only => ShopCategory.params } },
      :only     => ShopProduct.params
    }
  end
  
  dataset :users
    
  before(:each) do
    login_as  :admin
    
    @shop_category = Object.new
    @shop_categories = [ @shop_categories ]
    
    @shop_product = Object.new
    @shop_products = [ @shop_product ]
    
    stub(@shop_category).id { 1 }
    stub(@shop_product).id { 1 }
    stub(@shop_product).products { @shop_products }
  end
  
  describe '#index' do
    before :each do
      mock(ShopCategory).all { @shop_categories }
      mock(ShopProduct).find(:all) { @shop_products } # Resource Controller
      mock(ShopProduct).search('search') { @shop_products }
    end
    
    context 'html' do
      before :each do
        get :index, :search => 'search'
      end
      
      it 'should render index' do
        response.should render_template(:index)
      end
      
      it 'should assign the shop_products and shop_categories instance variables' do
        assigns(:shop_products).should === @shop_products
        assigns(:shop_categories).should === @shop_categories
      end
    end
    
    context 'js' do
      before :each do
        get :index, :search => 'search', :format => 'js'
      end
      
      it 'should render the collection partial and success status' do
        response.should be_success
        response.should render_template('/admin/shop/products/_product')
      end
      
      it 'should assign the shop_products instance variable' do
        assigns(:shop_products).should === @shop_products
      end
    end
    
    context 'json' do
      before :each do
        get :index, :search => 'search', :format => 'json'
      end
      
      it 'should return a json object of the array and success status' do
        response.should be_success
        response.body.should === @shop_products.to_json(ShopProduct.params)
      end
      
      it 'should assign the shop_product_images instance variable' do
        assigns(:shop_products).should === @shop_products
      end
    end
    
  end
  
  describe '#sort' do
    before :each do
      @products = [
        'shop_category_1_products[]=2',
        'shop_category_1_products[]=1'
      ].join('&')
    end
    
    context 'products are not passed' do
      context 'html' do
        it 'should assign an error and redirect to admin_shop_products_path path' do
          put :sort
          flash.now[:error].should_not be_nil
          response.should redirect_to(admin_shop_products_path)
        end
      end
      
      context 'js' do
        it 'should return an error string and failure status' do
          put :sort, :format => 'js'
          response.should_not be_success
          response.body.should === 'Could not sort Products.'
        end
      end
      
      context 'json' do
        it 'should return a json error object and failure status' do
          put :sort, :format => 'json'
          response.should_not be_success
          JSON.parse(response.body)['error'].should === 'Could not sort Products.'
        end
      end
    end
    
    context 'products are passed' do
      before :each do
        mock(ShopCategory).find('1') { @shop_category }
      end
      context 'could not sort' do
        before :each do
          mock(ShopProduct).find('2').stub!.update_attributes!(anything) { raise 'No Sorting' }
        end
        
        context 'html' do
          it 'should assign an error and redirect to admin_shop_products_path path' do
            put :sort, :products => @products, :category_id => 1
            flash.now[:error].should === 'Could not sort Products.'
            response.should redirect_to(admin_shop_products_path)
          end
        end
        
        context 'js' do
          it 'should return an error string and failure status' do
            put :sort, :products => @products, :category_id => 1, :format => 'js'
            response.should_not be_success
            response.body.should === 'Could not sort Products.'
          end
        end
        
        context 'json' do
          it 'should return a json error object and failure status' do
            put :sort, :products => @products, :category_id => 1, :format => 'json'
            response.should_not be_success
            JSON.parse(response.body)['error'].should === 'Could not sort Products.'
          end
        end
      end
      
      context 'successfully sorted' do
        before :each do
          mock(ShopProduct).find(anything).times(2).stub!.update_attributes!(anything) { true }
        end
        
        context 'html' do
          it 'should assign a notice and redirect to admin_shop_products_path path' do
            put :sort, :products => @products, :category_id => 1
            flash.now[:notice].should === 'Products successfully sorted.'
            response.should redirect_to(admin_shop_products_path)
          end
        end
        
        context 'js' do
          it 'should return success string and success status' do
            put :sort, :products => @products, :category_id => 1, :format => 'js'
            response.should be_success
            response.body.should === 'Products successfully sorted.'
          end
        end
        
        context 'json' do
          it 'should return a json success object and success status' do
            put :sort, :products => @products, :category_id => 1, :format => 'json'
            response.should be_success
            JSON.parse(response.body)['notice'].should === 'Products successfully sorted.'
          end
        end
      end
    end
  end
  
  describe '#create' do
    context 'product could not be created' do
      before :each do
        mock(ShopProduct).create!({}) { raise ActiveRecord::RecordNotSaved }
      end
      
      context 'html' do
        it 'should assign a flash error and render new' do
          post :create, :shop_product => {}
          
          response.should render_template(:new)
          flash.now[:error].should === 'Could not create Product.'
        end
      end
      
      context 'js' do
        it 'should return error notice and failure status' do
          post :create, :shop_product => {}, :format => 'js'
          
          response.body.should === 'Could not create Product.'
          response.should_not be_success
        end
      end
      
      context 'json' do
        it 'should return an error json object and failure status' do
          post :create, :shop_product => {}, :format => 'json'
          
          JSON.parse(response.body)['error'].should === 'Could not create Product.'
          response.should_not be_success
        end
      end
    end

    context 'product successfully created' do
      before :each do
        mock(ShopProduct).create!({}) { @shop_product }
      end
      
      context 'html' do
        context 'not continue' do
          it 'should assign a notice and redirect to edit_shop_product path' do
            post :create, :shop_product => {}
            flash.now[:notice].should === 'Product created successfully.'
            response.should redirect_to(admin_shop_products_path)
          end
        end
        context 'continue' do
          it 'should assign a notice and redirect to edit_shop_product path' do
            post :create, :shop_product => {}, :continue => true
            flash.now[:notice].should === 'Product created successfully.'
            response.should redirect_to(edit_admin_shop_product_path(@shop_product))
          end
        end
      end
      
      context 'js' do
        it 'should render the collection partial and success status' do
          post :create, :shop_product => {}, :format => 'js'
          response.should be_success
          assigns(:shop_product).should === @shop_product
          response.should render_template('/admin/shop/products/_product')
        end
      end
      
      context 'json' do
        it 'should render the json object and redirect to json show' do
          post :create ,:shop_product => {}, :format => 'json'
          response.should be_success
          response.body.should === @shop_product.to_json(ShopProduct.params)
        end
      end
    end
  end
  
  describe '#update' do
    before :each do
      mock(ShopProduct).find('1') { @shop_product }
    end
    
    context 'could not update' do
      before :each do
        stub(@shop_product).update_attributes!({}) { raise ActiveRecord::RecordNotSaved }
      end
      
      context 'html' do
        it 'should assign a flash error and render edit' do
          put :update, :id => @shop_product.id, :shop_product => {}        
          response.should render_template(:edit)
          flash.now[:error].should === 'Could not update Product.'
        end
      end
      
      context 'js' do
        it 'should render the error and failure status' do
          put :update, :id => @shop_product.id, :shop_product => {}, :format => 'js'
          response.should_not be_success
          response.body.should === 'Could not update Product.'
        end
      end
      
      context 'json' do
        it 'should assign an error json object and failure status' do
          put :update, :id => @shop_product.id, :shop_product => {}, :format => 'json'
          response.should_not be_success
          JSON.parse(response.body)['error'].should === 'Could not update Product.'
        end
      end
    end
    
    context 'successfully updated' do
      before :each do
        stub(@shop_product).update_attributes!({}) { true }
      end
      
      context 'html' do
        context 'not continue' do
          it 'should assign a notice and redirect to edit_shop_product path' do
            put :update, :id => @shop_product.id, :shop_product => {}
            flash.now[:notice].should === 'Product updated successfully.'
            response.should redirect_to(admin_shop_products_path)
          end
        end
        context 'continue' do
          it 'should assign a notice and redirect to edit_shop_product path' do
            put :update, :id => @shop_product.id, :shop_product => {}, :continue => true
            flash.now[:notice].should === 'Product updated successfully.'
            response.should redirect_to(edit_admin_shop_product_path(@shop_product))
          end
        end
      end
      
      context 'js' do
        it 'should render the partial and success status' do
          put :update, :id => @shop_product.id, :shop_product => {}, :format => 'js'
          response.should be_success
          response.should render_template('/admin/shop/products/_product')
        end
      end
      
      context 'json' do
        it 'should assign the json object and success status' do
          put :update, :id => @shop_product.id, :shop_product => {}, :format => 'json'
          response.should be_success
          response.body.should === @shop_product.to_json(ShopProduct.params)
        end
      end
    end
  end

  describe '#destroy' do
    before :each do
      mock(ShopProduct).find('1') { @shop_product }
    end
    
    context 'product not destroyed' do
      before :each do
        stub(@shop_product).destroy { raise ActiveRecord::RecordNotFound }
      end
      
      context 'html' do
        it 'should assign a flash error and render remove' do
          delete :destroy, :id => 1
          flash.now[:error].should === 'Could not delete Product.'
          response.should render_template(:remove)
        end
      end
      
      context 'js' do
        it 'should render an error and failure status' do
          delete :destroy, :id => 1, :format => 'js'
          response.body.should === 'Could not delete Product.'
          response.should_not be_success
        end
      end
      
      context 'json' do
        it 'should render an error and failure status' do
          delete :destroy, :id => 1, :format => 'json'
          JSON.parse(response.body)['error'].should === 'Could not delete Product.'
          response.should_not be_success
        end
      end
      
    end
    
    context 'product successfully destroyed' do
      before :each do
        stub(@shop_product).destroy { true }
      end
      
      context 'html' do
        it 'should assign a flash notice and redirect to shop_products path' do
          delete :destroy, :id => 1
          flash.now[:notice].should === 'Product deleted successfully.'
          response.should redirect_to(admin_shop_products_path)
        end
      end
      
      context 'js' do
        it 'should render success message and success status' do
          delete :destroy, :id => 1, :format => 'js'
          response.body.should === 'Product deleted successfully.'
          response.should be_success
        end
      end
      
      context 'json' do
        it 'should return a success json object and success status' do
          delete :destroy, :id => 1, :format => 'json'
          JSON.parse(response.body)['notice'].should === 'Product deleted successfully.'
          response.should be_success
        end
      end
    end
  end
  
end
