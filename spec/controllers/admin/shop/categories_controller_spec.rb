require 'spec/spec_helper'

describe Admin::Shop::CategoriesController do
  
  dataset :users
    
  before(:each) do
    login_as  :admin
    
    @shop_category = Object.new
    @shop_categories = [ @shop_category ]
    
    @shop_product = Object.new
    @shop_products = [ @shop_product ]
    
    stub(@shop_category).id { 1 }
    stub(@shop_category).products { @shop_products }
  end
  
  describe '#index' do
    before :each do
      mock(ShopCategory).find(:all) { @shop_categories } # Resource Controller
      mock(ShopCategory).search('search') { @shop_categories }
    end
    
    context 'html' do
      before :each do
        get :index, :search => 'search'
      end
      
      it 'should not assign an error or notice and redirect to shop_products path' do
        response.should redirect_to(admin_shop_products_path)
        flash.now[:error].should be_nil
        flash.now[:notice].should be_nil
      end
      
      it 'should assign the shop_product_images instance variable' do
        assigns(:shop_categories).should === @shop_categories
      end
    end
    
    context 'js' do
      before :each do
        get :index, :search => 'search', :format => 'js'
      end
      
      it 'should render the collection partial and success status' do
        response.should be_success
        response.should render_template('/admin/shop/categories/_category')
      end
      
      it 'should assign the shop_categories instance variable' do
        assigns(:shop_categories).should === @shop_categories
      end
    end
    
    context 'json' do
      before :each do
        get :index, :search => 'search', :format => 'json'
      end
      
      it 'should return a json object of the array and success status' do
        response.should be_success
        response.body.should === @shop_categories.to_json(ShopCategory.params)
      end
      
      it 'should assign the shop_product_images instance variable' do
        assigns(:shop_categories).should === @shop_categories
      end
    end
    
  end
  
  describe '#products' do
    before :each do
      mock(ShopCategory).find('1') { @shop_category }
    end
    
    context 'html' do
      before :each do
        get :products, :id => @shop_category.id
      end
      
      it 'should render successfully' do
        response.should render_template( '/admin/shop/products/index' )
      end
      
      it 'should assign the shop_products instance variable' do
        assigns(:shop_products).should ===  @shop_products
      end
    end
    
    context 'js' do
      before :each do
        get :products, :id => @shop_category.id, :format => 'js'
      end
      
      it 'should render the collection template' do
        response.should be_success
        response.should render_template( '/admin/shop/products/_product' )
      end
      
      it 'should assign the shop_products instance variable' do
        assigns(:shop_products).should ===  @shop_products
      end
    end
    
    context 'json' do
      before :each do
        get :products, :id => @shop_category.id, :format => 'json'
      end
      
      it 'should assign the shop_products and render the collection template' do
        response.should be_success
        response.body.should === @shop_products.to_json(ShopProduct.params)
      end

      it 'should assign the shop_products instance variable' do
        assigns(:shop_products).should ===  @shop_products
      end
    end
    
  end
  
  describe '#sort' do
    before :each do
      @categories = [
        'shop_categories[]=2',
        'shop_categories[]=1'
      ].join('&')
    end
    
    context 'categories are not passed' do
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
          response.body.should === 'Could not sort Categories.'
        end
      end
      
      context 'json' do
        it 'should return a json error object and failure status' do
          put :sort, :format => 'json'
          response.should_not be_success
          JSON.parse(response.body)['error'].should === 'Could not sort Categories.'
        end
      end
    end
    
    context 'categories are passed' do
      context 'could not sort' do
        before :each do
          mock(ShopCategory).find('2').stub!.update_attribute!('position',1) { raise 'No Sorting' }
        end
        
        context 'html' do
          it 'should assign an error and redirect to admin_shop_products_path path' do
            put :sort, :categories => @categories
            flash.now[:error].should === 'Could not sort Categories.'
            response.should redirect_to(admin_shop_products_path)
          end
        end
        
        context 'js' do
          it 'should return an error string and failure status' do
            put :sort, :categories => @categories, :format => 'js'
            response.should_not be_success
            response.body.should === 'Could not sort Categories.'
          end
        end
        
        context 'json' do
          it 'should return a json error object and failure status' do
            put :sort, :categories => @categories, :format => 'json'
            response.should_not be_success
            JSON.parse(response.body)['error'].should === 'Could not sort Categories.'
          end
        end
      end
      
      context 'successfully sorted' do
        before :each do
          mock(ShopCategory).find(anything).times(2).stub!.update_attribute!('position',anything) { true }
        end
        
        context 'html' do
          it 'should assign a notice and redirect to admin_shop_products_path path' do
            put :sort, :categories => @categories
            flash.now[:notice].should === 'Categories successfully sorted.'
            response.should redirect_to(admin_shop_products_path)
          end
        end
        
        context 'js' do
          it 'should return success string and success status' do
            put :sort, :categories => @categories, :format => 'js'
            response.should be_success
            response.body.should === 'Categories successfully sorted.'
          end
        end
        
        context 'json' do
          it 'should return a json success object and success status' do
            put :sort, :categories => @categories, :format => 'json'
            response.should be_success
            JSON.parse(response.body)['notice'].should === 'Categories successfully sorted.'
          end
        end
      end
    end
  end
  
  describe '#create' do
    context 'category could not be created' do
      before :each do
        mock(ShopCategory).create!({}) { raise ActiveRecord::RecordNotSaved }
      end
      
      context 'html' do
        it 'should assign a flash error and render new' do
          post :create, :shop_category => {}
          
          response.should render_template(:new)
          flash.now[:error].should === 'Could not create Category.'
        end
      end
      
      context 'js' do
        it 'should return error notice and failure status' do
          post :create, :shop_category => {}, :format => 'js'
          
          response.body.should === 'Could not create Category.'
          response.should_not be_success
        end
      end
      
      context 'json' do
        it 'should return an error json object and failure status' do
          post :create, :shop_category => {}, :format => 'json'
          
          JSON.parse(response.body)['error'].should === 'Could not create Category.'
          response.should_not be_success
        end
      end
    end

    context 'category successfully created' do
      before :each do
        mock(ShopCategory).create!({}) { @shop_category }
      end
      
      context 'html' do
        context 'not continue' do
          it 'should assign a notice and redirect to edit_shop_product path' do
            post :create, :shop_category => {}
            flash.now[:notice].should === 'Category created successfully.'
            response.should redirect_to(admin_shop_categories_path)
          end
        end
        context 'continue' do
          it 'should assign a notice and redirect to edit_shop_product path' do
            post :create, :shop_category => {}, :continue => true
            flash.now[:notice].should === 'Category created successfully.'
            response.should redirect_to(edit_admin_shop_category_path(@shop_category))
          end
        end
      end
      
      context 'js' do
        it 'should render the collection partial and success status' do
          post :create, :shop_category => {}, :format => 'js'
          response.should be_success
          assigns(:shop_category).should === @shop_category
          response.should render_template('/admin/shop/categories/_category')
        end
      end
      
      context 'json' do
        it 'should render the json object and redirect to json show' do
          post :create ,:shop_category => {}, :format => 'json'
          response.should be_success
          response.body.should === @shop_category.to_json(ShopCategory.params)
        end
      end
    end
  end
  
  describe '#update' do
    before :each do
      mock(ShopCategory).find('1') { @shop_category }
    end
    
    context 'could not update' do
      before :each do
        stub(@shop_category).update_attributes!({}) { raise ActiveRecord::RecordNotSaved }
      end
      
      context 'html' do
        it 'should assign a flash error and render edit' do
          put :update, :id => @shop_category.id, :shop_category => {}        
          response.should render_template(:edit)
          flash.now[:error].should === 'Could not update Category.'
        end
      end
      
      context 'js' do
        it 'should render the error and failure status' do
          put :update, :id => @shop_category.id, :shop_category => {}, :format => 'js'
          response.should_not be_success
          response.body.should === 'Could not update Category.'
        end
      end
      
      context 'json' do
        it 'should assign an error json object and failure status' do
          put :update, :id => @shop_category.id, :shop_category => {}, :format => 'json'
          response.should_not be_success
          JSON.parse(response.body)['error'].should === 'Could not update Category.'
        end
      end
    end
    
    context 'successfully updated' do
      before :each do
        stub(@shop_category).update_attributes!({}) { true }
      end
      
      context 'html' do
        context 'not continue' do
          it 'should assign a notice and redirect to edit_shop_product path' do
            put :update, :id => @shop_category.id, :shop_category => {}
            flash.now[:notice].should === 'Category updated successfully.'
            response.should redirect_to(admin_shop_categories_path)
          end
        end
        context 'continue' do
          it 'should assign a notice and redirect to edit_shop_product path' do
            put :update, :id => @shop_category.id, :shop_category => {}, :continue => true
            flash.now[:notice].should === 'Category updated successfully.'
            response.should redirect_to(edit_admin_shop_category_path(@shop_category))
          end
        end
      end
      
      context 'js' do
        it 'should render the partial and success status' do
          put :update, :id => @shop_category.id, :shop_category => {}, :format => 'js'
          response.should be_success
          response.should render_template('/admin/shop/categories/_category')
        end
      end
      
      context 'json' do
        it 'should assign the json object and success status' do
          put :update, :id => @shop_category.id, :shop_category => {}, :format => 'json'
          response.should be_success
          response.body.should === @shop_category.to_json(ShopCategory.params)
        end
      end
    end
  end

  describe '#destroy' do
    before :each do
      mock(ShopCategory).find('1') { @shop_category }
    end
    
    context 'product not destroyed' do
      before :each do
        stub(@shop_category).destroy { raise ActiveRecord::RecordNotFound }
      end
      
      context 'html' do
        it 'should assign a flash error and render remove' do
          delete :destroy, :id => 1
          flash.now[:error].should === 'Could not delete Category.'
          response.should render_template(:remove)
        end
      end
      
      context 'js' do
        it 'should render an error and failure status' do
          delete :destroy, :id => 1, :format => 'js'
          response.body.should === 'Could not delete Category.'
          response.should_not be_success
        end
      end
      
      context 'json' do
        it 'should render an error and failure status' do
          delete :destroy, :id => 1, :format => 'json'
          JSON.parse(response.body)['error'].should === 'Could not delete Category.'
          response.should_not be_success
        end
      end
      
    end
    
    context 'product successfully destroyed' do
      before :each do
        stub(@shop_category).destroy { true }
      end
      
      context 'html' do
        it 'should assign a flash notice and redirect to shop_categories path' do
          delete :destroy, :id => 1
          flash.now[:notice].should === 'Category deleted successfully.'
          response.should redirect_to(admin_shop_categories_path)
        end
      end
      
      context 'js' do
        it 'should render success message and success status' do
          delete :destroy, :id => 1, :format => 'js'
          response.body.should === 'Category deleted successfully.'
          response.should be_success
        end
      end
      
      context 'json' do
        it 'should return a success json object and success status' do
          delete :destroy, :id => 1, :format => 'json'
          JSON.parse(response.body)['notice'].should === 'Category deleted successfully.'
          response.should be_success
        end
      end
    end
  end
  
end
