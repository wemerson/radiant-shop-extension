require File.dirname(__FILE__) + '/../../../spec_helper'

describe Admin::Shop::ProductsController do
  dataset :users, :shop_products
  
  before :each do
    @product = shop_products(:soft_bread)
    @products = [
      shop_products(:soft_bread),
      shop_products(:crusty_bread),
      shop_products(:warm_bread),
      shop_products(:full_milk),
      shop_products(:hilo_milk),
      shop_products(:choc_milk)
    ]
  end
  
  describe "#index" do    
    
    context "user not logged in" do

      before :each do 
        get :index
      end

      it "should redirect to #login" do
        response.should redirect_to(login_path)
      end

    end
    
    context "user logged in" do
    
      before :each do
        login_as :admin
        get :index
      end
      
      it "should render successfully" do
        response.should be_success
      end
      
      it "should have a list of products" do
        assigns(:shop_products).length.should == @products.length
      end
      
    end
    
  end
  
  describe "#show" do 
    
    context "user not logged in" do

      before :each do 
        get :show, :id => @product.id
      end

      it "should redirect to #login" do
        response.should redirect_to(login_path)
      end

    end
    
    context "user logged in" do
    
      before :each do
        login_as :admin
      end
    
      context "product does not exist" do
    
        before :each do
          get :show, :id => 0
        end
      
        it "should redirect to #edit" do
          response.should be_redirect
          response.body.include?('/edit')
        end
    
      end
    
      context "product exists" do
      
        before :each do
          get :show, :id => @product.id
        end
      
        it "should render" do
          response.should be_success
        end

        it "should define the product" do
          assigns[:shop_product].should == @product
        end
      
      end
      
    end
    
  end
  
  describe "#new" do
    
    context "user not logged in" do

      before :each do 
        get :show, :id => @product.id
      end

      it "should redirect to #login" do
        response.should redirect_to(login_path)
      end

    end
    
    context "user logged in" do
    
      before :each do
        login_as :admin
      end
    
      context "no category assigned" do
    
        before :each do
          get :new, :category_id => 0
        end
      
        it "should redirect to #index" do
          response.should redirect_to(admin_shop_products_path)
        end
    
        it "should have a flash message" do
          flash.now[:notice].should == "Product could not be found."
        end
    
      end
    
      context "category assigned" do
      
        before :each do
          get :new, :category_id => shop_categories(:bread).id
        end
      
        it "should render" do
          response.should be_success
        end
        
        it "should define the product" do
          assigns[:shop_product].class.should == ShopProduct
        end
        
        it "should have defined the category" do
          assigns[:shop_product].category.should == shop_categories(:bread)
        end
      
      end
      
    end
    
  end
  
  describe "#create" do
    
    context "user not logged in" do

      before :each do 
        post :create, :shop_product => @product
      end

      it "should redirect to #login" do
        response.should redirect_to(login_path)
      end

    end
    
    context "user logged in" do
    
      before :each do
        login_as :admin
      end
    
      context "no product data sent" do
    
        before :each do
          post :create, :shop_product => {}
        end
      
        it "should just render its self" do
          response.should be_success
        end
    
        it "should have a flash message" do
          flash.now[:error].should == "Unable to create new product."
        end
    
      end
      
      context "product data sent" do
        
        before :all do 
          @data = {
            :title => "new bread",
            :category => shop_categories(:bread)
          }
        end
      
        context 'save and continue' do
          
          before :each do
            post :create, :shop_product => @data, :continue => true
          end

          it "should redirect back to edit" do
            response.should redirect_to(edit_admin_shop_product_path(assigns[:shop_product]))
          end

          it "should create the product" do
            assigns[:shop_product].title.should == @data[:title]
            assigns[:shop_product].category.should == @data[:category]
            assigns[:shop_product].id.should_not be_nil
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
            assigns[:shop_product].title.should == @data[:title]
            assigns[:shop_product].category.should == @data[:category]
            assigns[:shop_product].id.should_not be_nil
          end
          
        end
      end
      
    end
    
  end
  
  describe "#edit" do
    
    context "user not logged in" do

      before :each do 
        get :show, :id => @product.id
      end

      it "should redirect to #login" do
        response.should redirect_to(login_path)
      end

    end
    
    context "user logged in" do
    
      before :each do
        login_as :admin
      end
    
      context "product does not exist" do
    
        before :each do
          get :edit, :id => 0
        end
      
        it "should redirect to #index" do
          response.should redirect_to(admin_shop_products_path)
        end
    
        it "should have a flash message" do
          flash.now[:notice].should == "Product could not be found."
        end
    
      end
    
      context "product exists" do
      
        before :each do
          get :edit, :id => @product.id
        end
      
        it "should render" do
          response.should be_success
        end
        
        it "should define the product" do
          assigns[:shop_product].should == @product
        end
      
      end
      
    end
    
  end
  
  describe "#update" do
    
    context "user not logged in" do

      before :each do 
        put :update, :id => @product.id
      end

      it "should redirect to #login" do
        response.should redirect_to(login_path)
      end

    end
    
    context "user logged in" do
    
      before :each do
        login_as :admin
      end
    
      context "product does not exist" do
    
        before :each do
          put :update, :id => 0
        end
      
        it "should redirect to #index" do
          response.should redirect_to(admin_shop_products_path)
        end
    
        it "should have a flash message" do
          flash.now[:notice].should == "Product could not be found."
        end
    
      end
    
      context "product exists" do
      
        before :all do 
          @title = "new title"
        end
      
        context 'save and continue' do
          
          before :each do
            put :update, :id => @product.id, :shop_product => { :title => @title }, :continue => true
          end

          it "should redirect back to edit" do
            response.should redirect_to(edit_admin_shop_product_path(@product))
          end

          it "should define the product" do
            assigns[:shop_product].should == @product
          end
          
          it "should update the product title" do
            @product = ShopProduct.find(@product.id)
            @product.title.should == @title
          end
          
        end
        
        context 'save' do
          
          before :each do
            put :update, :id => @product.id, :shop_product => { :title => @title }
          end

          it "should redirect back to edit" do
            response.should redirect_to(admin_shop_products_path)
          end

          it "should define the product" do
            assigns[:shop_product].should == @product
          end
          
          it "should update the product title" do
            @product = ShopProduct.find(@product.id)
            @product.title.should == @title
          end
          
        end
      
      end
      
    end
    
  end
  
  describe "#remove" do
    
    context "user not logged in" do

      before :each do 
        get :remove, :id => @product.id
      end

      it "should redirect to #login" do
        response.should redirect_to(login_path)
      end

    end
    
    context "user logged in" do
    
      before :each do
        login_as :admin
      end
    
      context "product does not exist" do
    
        before :each do
          get :remove, :id => 0
        end
      
        it "should redirect to #index" do
          response.should redirect_to(admin_shop_products_path)
        end

        it "should have a flash message" do
          flash.now[:notice].should == "Product could not be found."
        end
    
      end
    
      context "product exists" do
      
        before :each do
          get :remove, :id => @product.id
        end
      
        it "should render" do
          response.should be_success
        end
        
        it "should define the product" do
          assigns[:shop_product].should == @product
        end
      
      end
      
    end
    
  end
  
  describe "#destroy" do
    
    context "user not logged in" do

      before :each do 
        delete :destroy, :id => @product.id
      end

      it "should redirect to #login" do
        response.should redirect_to(login_path)
      end

    end
    
    context "user logged in" do
    
      before :each do
        login_as :admin
      end
    
      context "product does not exist" do
    
        before :each do
          delete :destroy, :id => 0
        end
      
        it "should redirect to #index" do
          response.should redirect_to(admin_shop_products_path)
        end

        it "should have a flash message" do
          flash.now[:notice].should == "Product could not be found."
        end
    
      end
    
      context "product exists" do
      
        before :each do
          @length = ShopProduct.all.length
          delete :destroy, :id => @product.id
        end
      
        it "should redirect to #index" do
          response.should redirect_to(admin_shop_products_path)
        end
        
        it "should have a flash message" do
          flash.now[:notice].should == "Product deleted successfully."
        end
        
        it "should have deleted the product" do
          ShopProduct.all.length.should == (@length - 1)
        end
      
      end
      
    end
    
  end
  
  describe "#sort" do    
    
    context "user not logged in" do

      before :each do 
        put :sort
      end

      it "should redirect to #login" do
        response.should redirect_to(login_path)
      end

    end
    
    context "user logged in" do
    
      before :each do
        login_as :admin
      end
    
      context "category does not exist" do
    
        before :each do
          put :sort, :category_id => 0
        end
      
        it "should redirect to #index" do
          response.should redirect_to(admin_shop_products_path)
        end

        it "should have a flash message" do
          flash.now[:notice].should == "Product could not be found."
        end
    
      end
    
      context "category is passed" do
        
        context "products are not passed" do
          
          before :each do
            put :sort, :category_id => shop_categories(:bread).id
          end
          
        end
        
        context "products are passed" do
          
          before :all do
            @category = shop_categories(:bread)
            @sort = [
              "shop_category_#{@category.id}_products[]=#{shop_products(:warm_bread).id}",
              "shop_category_#{@category.id}_products[]=#{shop_products(:crusty_bread).id}",
              "shop_category_#{@category.id}_products[]=#{shop_products(:soft_bread).id}",
            ]
          end
          
          before :each do
            put :sort, :category_id => @category.id, :products => @sort.join('&')
          end
                    
          it "should redirect to #index" do
            response.should redirect_to(admin_shop_products_path)
          end

          it "should have a flash message" do
            flash.now[:notice].should == "Products sorted successfully."
          end
          
          it "should have reordered them" do
            shop_products(:warm_bread).position.should == 1
            shop_products(:soft_bread).position.should == 3
          end

        end
      
      end
      
    end
    
  end
  
end