require 'spec/spec_helper'

describe Admin::Shop::ProductsController do
  dataset :users, :shop_products
  
  before :all do
    @product = shop_products(:soft_bread)
    @category = @product.category
    @products = [
      shop_products(:soft_bread),
      shop_products(:full_milk),
      shop_products(:crusty_bread),
      shop_products(:hilo_milk),
      shop_products(:warm_bread),
      shop_products(:choc_milk)
    ]
  end
  
  before :each do
    login_as :admin
  end
  
  describe '#index' do
    
    context 'html' do
      
      before :each do
        get :index
      end
      
      it 'should render successfully' do
        response.should be_success
      end
      
      it 'should have a list of products' do
        assigns(:shop_products).should == @products
      end
      
    end
    
    context 'js' do
      
      before :each do
        get :index, :format => 'js'
      end
      
      it 'should render successfully' do
        response.should render_template('/admin/shop/products/_product')
      end
      
    end
    
  end
  
  describe '#sort' do
    
    context 'products are not passed' do
      
      before :each do
        put :sort, :category_id => shop_categories(:bread).id, :products => nil
      end
      
      it 'should redirect to #index' do
        response.should redirect_to(admin_shop_products_path)
      end
      
      it 'should have a flash message' do
        flash.now[:error].should == "Couldn't sort Products"
      end
      
    end
    
    context 'products are passed' do
      
      before :each do
        @sort = [
          "shop_category_#{@category.id}_products[]=#{@products[4].id}",
          "shop_category_#{@category.id}_products[]=#{@products[2].id}",
          "shop_category_#{@category.id}_products[]=#{@products[0].id}",
        ]
      end
      
      context 'html' do
        
        before :each do
          put :sort, :category_id => @category.id, :products => @sort.join('&')
        end
        
        it 'should redirect to #index' do
          response.should redirect_to(admin_shop_products_path)
        end
        
        it 'should have a flash message' do
          flash.now[:notice].should == "Products sorted successfully"
        end
        
        it 'should have reordered them' do
          assigns(:shop_products)[0].should == @products[4].id.to_s
          assigns(:shop_products)[1].should == @products[2].id.to_s
          assigns(:shop_products)[2].should == @products[0].id.to_s
        end
        
      end
      
      context 'js' do
        
        before :each do
          put :sort, :category_id => @category.id, :products => @sort.join('&'), :format => 'js'
        end
        
        it 'should return success notice' do
          response.body.should == 'Products sorted successfully'
        end
        
        it 'should have reordered them' do
          shop_products(:soft_bread).position.should == 3
          shop_products(:crusty_bread).position.should == 2
          shop_products(:warm_bread).position.should == 1
        end
        
      end
      
    end
    
  end
  
  describe '#create' do
    
    context 'category could not be created' do
      
      before :each do
        post :create, :shop_product => {}
      end
      
      it 'should just render new template' do
        response.should render_template(:new)
      end
      
      it 'should have a flash message' do
        flash.now[:error].should == "Couldn't create Product"
      end
      
    end
    
    context 'category successfully created' do
      
      before :all do 
        @data = {
          :name     => 'name',
          :category => shop_categories(:bread)
        }
      end
      
      context 'html' do
        
        context 'save and continue' do
          
          before :each do
            post :create, :shop_product => @data, :continue => true
          end
          
          it 'should redirect back to edit' do
            response.should redirect_to(edit_admin_shop_product_path(assigns[:shop_product]))
          end
          
          it 'should create the product' do
            flash.now[:notice].should == "Product created successfully"
          end
          
        end
        
        context 'save' do
          
          before :each do
            post :create, :shop_product => @data
          end
          
          it "should redirect back to edit" do
            response.should redirect_to(admin_shop_products_path)
          end
          
          it "should create the product" do
            flash.now[:notice].should == "Product created successfully"
          end
          
        end
        
      end
      
      context 'js' do
        
        before :each do
          post :create, :shop_product => @data, :format => 'js'
        end
        
        it 'should render the category excerpt template' do
          response.should render_template( '/admin/shop/products/_product' )
        end
        
      end
      
    end
    
  end
  
  describe '#update' do

    context 'could not be saved' do
      
      before :each do
        put :update, :id => @product.id, :shop_product => { :name => nil }
      end
      
      it "should redirect back to edit" do
        response.should render_template(:edit)
      end
      
      it "should define the product" do
        assigns(:shop_product).should == @product
      end
      
      it 'should assign a flash error' do
        flash.now[:error].should == "Couldn't update Product"
      end
      
    end
    
    context 'successfully saved' do
      
      context 'html' do
        
        context 'save and continue' do
          
          before :each do
            put :update, :id => @product.id, :shop_product => { :name => 'name' }, :continue => true
          end
          
          it 'should redirect back to edit' do
            response.should redirect_to(edit_admin_shop_product_path(@product))
          end
          
          it "should define the product" do
            assigns(:shop_product).should == @product
          end
          
          it 'should assign a flash notice' do
            flash.now[:notice].should == "Product updated successfully"
          end
          
        end
        
        context 'save' do
          
          before :each do
            put :update, :id => @product.id, :shop_product => { :name => 'name' }
          end
          
          it 'should redirect back to edit' do
            response.should redirect_to(admin_shop_products_path)
          end
          
          it 'should define the product' do
            assigns(:shop_product).should == @product
          end
          
          it 'should assign a flash notice' do
            flash.now[:notice].should == "Product updated successfully"
          end
          
        end
        
      end
      
      context 'js' do
        
        before :each do
          put :update, :id => @product.id, :shop_product => { :name => 'name' }, :format => 'js'
        end
        
        it 'should render the category excerpt template' do
          response.should render_template( '/admin/shop/products/_product' )
        end
        
      end
      
    end
    
  end
  
  describe '#destroy' do
    
    context 'product not destroyed' do
      
      before :each do
        @length = ShopProduct.all.length
        delete :destroy, :id => 0
      end
      
      it 'should redirect to #index' do
        response.should redirect_to(admin_shop_products_path)
      end
      
      it 'should have a flash message' do
        flash.now[:notice].should == "Product could not be found."
      end
      
      it 'should have deleted the product' do
        ShopProduct.all.length.should == @length
      end
      
    end
    
    context 'product destroyed' do
      
      before :each do
        @length = ShopProduct.all.length
        delete :destroy, :id => @product.id
      end
      
      it 'should redirect to #index' do
        response.should redirect_to(admin_shop_products_path)
      end
      
      it 'should have a flash message' do
        flash.now[:notice].should == "Product deleted successfully"
      end
      
      it 'should have deleted the product' do
        ShopProduct.all.length.should == (@length - 1)
      end
      
    end
    
  end
  
end
