require File.dirname(__FILE__) + '/../../../spec_helper'

describe Admin::Shop::CategoriesController do
  dataset :users, :shop_categories
  
  before :each do
    @category = shop_categories(:bread)
    @categories = [
      shop_categories(:bread),
      shop_categories(:milk)
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
        response.should redirect_to(admin_shop_products_path)
      end
      
      it "should have a list of categories" do
        assigns(:shop_categories).length.should == @categories.length
      end
      
    end
    
  end
  
  describe "#show" do 
    
    context "user not logged in" do

      before :each do 
        get :show, :id => @category.id
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
          get :show, :id => 0
        end
      
        it "should redirect to #edit" do
          response.should be_redirect
          response.body.include?('/edit')
        end
    
      end
    
      context "category exists" do
      
        before :each do
          get :show, :id => @category.id
        end
      
        it "should render" do
          response.should be_success
        end

        it "should define the product" do
          assigns[:shop_category].should == @category
        end
      
      end
      
    end
    
  end
  
  describe "#new" do
    
    context "user not logged in" do

      before :each do 
        get :show, :id => @category.id
      end

      it "should redirect to #login" do
        response.should redirect_to(login_path)
      end

    end
    
    context "user logged in" do
    
      before :each do
        login_as :admin
      end
    
      context "category assigned" do
      
        before :each do
          get :new
        end
      
        it "should render" do
          response.should be_success
        end
        
        it "should define the category" do
          assigns[:shop_category].class.should == ShopCategory
        end
      
      end
      
    end
    
  end
  
  describe "#create" do
    
    context "user not logged in" do

      before :each do 
        post :create, :shop_category => @category
      end

      it "should redirect to #login" do
        response.should redirect_to(login_path)
      end

    end
    
    context "user logged in" do
    
      before :each do
        login_as :admin
      end
    
      context "no category data sent" do
    
        before :each do
          post :create, :shop_category => {}
        end
      
        it "should just render its self" do
          response.should be_success
        end
    
        it "should have a flash message" do
          flash.now[:error].should == "Unable to create new category."
        end
    
      end
      
      context "category data sent" do
        
        before :all do 
          @data = {
            :title => "new category"
          }
        end
      
        context 'save and continue' do
          
          before :each do
            post :create, :shop_category => @data, :continue => true
          end

          it "should redirect back to edit" do
            response.should redirect_to(edit_admin_shop_category_path(assigns[:shop_category]))
          end

          it "should create the product" do
            assigns[:shop_category].title.should == @data[:title]
            assigns[:shop_category].id.should_not be_nil
            assigns[:shop_category].valid?
          end
          
        end
        
        context 'save' do
          
          before :each do
            post :create, :shop_category => @data
          end

          it "should redirect back to edit" do
            response.should redirect_to(admin_shop_categories_path)
          end

          it "should create the category" do
            assigns[:shop_category].title.should == @data[:title]
            assigns[:shop_category].id.should_not be_nil
            assigns[:shop_category].valid?
          end
          
        end
      end
      
    end
    
  end
  
  describe "#edit" do
    
    context "user not logged in" do

      before :each do 
        get :show, :id => @category.id
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
          get :edit, :id => 0
        end
      
        it "should redirect to #index" do
          response.should redirect_to(admin_shop_categories_path)
        end
    
        it "should have a flash message" do
          flash.now[:notice].should == "Category could not be found."
        end
    
      end
    
      context "category exists" do
      
        before :each do
          get :edit, :id => @category.id
        end
      
        it "should render" do
          response.should be_success
        end
        
        it "should define the product" do
          assigns[:shop_category].should == @category
        end
      
      end
      
    end
    
  end
  
  describe "#update" do
    
    context "user not logged in" do

      before :each do 
        put :update, :id => @category.id
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
          put :update, :id => 0
        end
      
        it "should redirect to #index" do
          response.should redirect_to(admin_shop_categories_path)
        end
    
        it "should have a flash message" do
          flash.now[:notice].should == "Category could not be found."
        end
    
      end
    
      context "category exists" do
      
        before :all do 
          @title = "new title"
        end
      
        context 'save and continue' do
          
          before :each do
            put :update, :id => @category.id, :shop_category => { :title => @title }, :continue => true
          end

          it "should redirect back to edit" do
            response.should redirect_to(edit_admin_shop_category_path(@category))
          end

          it "should define the product" do
            assigns[:shop_category].should == @category
          end
          
          it "should update the product title" do
            @category = ShopCategory.find(@category.id)
            @category.title.should == @title
          end
          
        end
        
        context 'save' do
          
          before :each do
            put :update, :id => @category.id, :shop_category => { :title => @title }
          end

          it "should redirect back to edit" do
            response.should redirect_to(admin_shop_categories_path)
          end

          it "should define the product" do
            assigns[:shop_category].should == @category
          end
          
          it "should update the category title" do
            @category = ShopCategory.find(@category.id)
            @category.title.should == @title
          end
          
        end
      
      end
      
    end
    
  end
  
  describe "#remove" do
    
    context "user not logged in" do

      before :each do 
        get :remove, :id => @category.id
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
          get :remove, :id => 0
        end
      
        it "should redirect to #index" do
          response.should redirect_to(admin_shop_categories_path)
        end

        it "should have a flash message" do
          flash.now[:notice].should == "Category could not be found."
        end
    
      end
    
      context "category exists" do
      
        before :each do
          get :remove, :id => @category.id
        end
      
        it "should render" do
          response.should be_success
        end
        
        it "should define the category" do
          assigns[:shop_category].should == @category
        end
      
      end
      
    end
    
  end
  
  describe "#destroy" do
    
    context "user not logged in" do

      before :each do 
        delete :destroy, :id => @category.id
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
          delete :destroy, :id => 0
        end
      
        it "should redirect to #index" do
          response.should redirect_to(admin_shop_categories_path)
        end

        it "should have a flash message" do
          flash.now[:notice].should == "Category could not be found."
        end
    
      end
    
      context "category exists" do
      
        before :each do
          @length = ShopCategory.all.length
          delete :destroy, :id => @category.id
        end
      
        it "should redirect to #index" do
          response.should redirect_to(admin_shop_categories_path)
        end
        
        it "should have a flash message" do
          flash.now[:notice].should == "Category deleted successfully."
        end
        
        it "should have deleted the category" do
          ShopCategory.all.length.should == (@length - 1)
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
    
      context "categories dont not exist" do
    
        before :each do
          put :sort, :categories => nil
        end
      
        it "should redirect to #index" do
          response.should redirect_to(admin_shop_products_path)
        end

        it "should have a flash message" do
          flash.now[:error].should == "Couldn't sort Categories."
        end
    
      end
    
      context "categories are passed" do
        
        before :all do
          @sort = [
            "shop_categories[]=#{shop_categories(:milk).id}",
            "shop_categories[]=#{shop_categories(:bread).id}",
          ]
        end
        
        before :each do
          put :sort, :categories => @sort.join('&')
        end
                  
        it "should redirect to #index" do
          response.should redirect_to(admin_shop_products_path)
        end

        it "should have a flash message" do
          flash.now[:notice].should == "Categories sorted successfully."
        end
        
        it "should have reordered them" do
          shop_categories(:milk).position.should == 1
          shop_categories(:bread).position.should == 2
        end
      
      end
      
    end
    
  end
  
end