require File.dirname(__FILE__) + '/../../../spec_helper'

describe Admin::Shop::CategoriesController do
  
  dataset :users, :shop_categories
  
  before :all do
    @category = shop_categories(:bread)
    @categories = [
      shop_categories(:bread),
      shop_categories(:milk)
    ]
  end

  # As far as I'm concerned if Admin:: stops authenticated we're all going down  
  before :each do
    login_as  :admin
  end
  
  describe '#index' do
    
    context 'html' do
      
      before :each do
        get :index
      end
      
      it 'should render successfully' do
        response.should redirect_to(admin_shop_products_url)
      end
      
      it 'should have a list of categories' do
        assigns(:shop_categories).should == @categories
      end
      
    end
    
    context 'js' do
      
      before :each do
        get :index, :format => 'js'
      end
      
      it 'should render successfully' do
        response.should render_template( '/admin/shop/categories/_category' )
      end
      
    end
    
  end
  
  describe '#products' do
    
    context 'html' do
      
      before :each do
        get :products, :id => @category.id
      end
      
      it 'should render successfully' do
        response.should render_template( '/admin/shop/products/index' )
      end
      
      it 'should have a list of categories' do
        assigns(:shop_category).should == @category
        assigns(:shop_categories).class.should == Array
        assigns(:shop_products).class.should == Array
      end
      
    end
    
    context 'js' do
      
      before :each do
        get :products, :id => @category.id, :format => 'js'
      end
      
      it 'should render successfully' do
        response.should render_template( '/admin/shop/products/_product' )
      end
      
    end
    
  end
  
  describe '#sort' do
    
    before :each do
      @sort = [
        "shop_categories[]=#{shop_categories(:milk).id}",
        "shop_categories[]=#{shop_categories(:bread).id}",
      ]
    end
    
    context 'categories are not passed' do
      
      before :each do
        put :sort, :categories => nil
      end
      
      it 'should redirect to #index' do
        response.should redirect_to(admin_shop_products_path)
      end
      
      it 'should have a flash message' do
        flash.now[:error].should == "Couldn't sort Categories"
      end
      
    end
    
    context 'categories are passed' do
      
      context 'html' do
        
        before :each do
          put :sort, :categories => @sort.join('&')
        end
          
        it 'should redirect to #index' do
          response.should redirect_to(admin_shop_products_path)
        end
        
        it 'should have a flash message' do
          flash.now[:notice].should == "Categories sorted successfully"
        end
        
        it 'should have reordered them' do
          shop_categories(:milk).position.should == 1
          shop_categories(:bread).position.should == 2
        end
        
      end
      
      context 'js' do
        
        before :each do
          get :sort, :categories => @sort.join('&'), :format => 'js'
        end
        
        it 'should render successfully' do
          response.body.should == "Categories sorted successfully"
        end
        
      end
      
    end
    
  end
  
  describe '#show' do 
    
    before :each do
      login_as :admin
    end
    
    context 'category exists' do
      
      context 'html' do
        
        before :each do
          get :show, :id => @category.id
        end
        
        it 'should render' do
          response.should render_template(:show)
        end
        
        it 'should define the product' do
          assigns(:shop_category).should == @category
        end
        
      end
      
      context 'js' do
        
        before :each do
          get :show, :id => @category.id, :format => 'js'
        end
        
        it 'should render successfully' do
          response.should render_template( '/admin/shop/categories/_category' )
        end
        
      end
      
    end
    
  end
  
  describe '#create' do
    
    context 'category could not be created' do
      
      before :each do
        post :create, :shop_category => { :name => nil }
      end
      
      it 'should just render new template' do
        response.should render_template(:new)
      end
      
      it 'should have a flash message' do
        flash.now[:error].should == "Couldn't create Category"
      end
      
    end
    
    context 'category successfully created' do
      
      context 'html' do
        
        context 'save and continue' do
          
          before :each do
            post :create, :shop_category => { :name => 'name' }, :continue => true
          end
          
          it "should redirect back to edit" do
            response.should redirect_to(edit_admin_shop_category_path(assigns[:shop_category]))
          end
          
          it "should create the product" do
            flash.now[:notice].should == "Category created successfully"
          end
          
        end
        
        context 'save' do
          
          before :each do
            post :create, :shop_category => { :name => 'name' }
          end
          
          it 'should redirect back to edit' do
            response.should redirect_to(admin_shop_categories_path)
          end
          
          it 'should create the product' do
            flash.now[:notice].should == "Category created successfully"
          end
          
        end
        
      end
      
      context 'js' do
        
        before :each do
          post :create, :shop_category => { :name => 'name' }, :format => 'js'
        end
        
        it 'should render the category excerpt template' do
          response.should render_template( '/admin/shop/categories/_category' )
        end
        
      end
      
    end
    
  end 
  
  describe '#update' do
    
    context 'could not be saved' do
      
      before :each do
        put :update, :id => @category.id, :shop_category => { :name => nil }
      end
      
      it "should redirect back to edit" do
        response.should render_template(:edit)
      end
      
      it "should define the product" do
        assigns(:shop_category).should == @category
      end
      
      it 'should assign a flash notice' do
        flash.now[:error].should == "Couldn't update Category"
      end
      
    end
    
    context 'successfully saved' do
      
      context 'html' do
        
        context 'save and continue' do
          
          before :each do
            put :update, :id => @category.id, :shop_category => { :name => 'name' }, :continue => true
          end
          
          it 'should redirect back to edit' do
            response.should redirect_to(edit_admin_shop_category_path(@category))
          end
          
          it 'should define the product' do
            assigns(:shop_category).should == @category
          end
          
          it 'should assign a flash notice' do
            flash.now[:notice].should == "Category updated successfully"
          end
          
        end
        
        context 'save' do
          
          before :each do
            put :update, :id => @category.id, :shop_category => { :name => 'name' }
          end
          
          it 'should redirect back to edit' do
            response.should redirect_to(admin_shop_categories_path)
          end
          
          it 'should define the product' do
            assigns(:shop_category).should == @category
          end
          
          it 'should assign a flash notice' do
            flash.now[:notice].should == "Category updated successfully"
          end
        
        end
        
      end
      
      context 'js' do
        
        before :each do
          put :update, :id => @category.id, :shop_category => { :name => 'name' }, :format => 'js'
        end
        
        it 'should render the category excerpt template' do
          response.should render_template( '/admin/shop/categories/_category' )
        end
        
      end
      
    end
    
  end
  
  describe '#destroy' do
    
    context 'product not destroyed' do
      
      before :each do
        @length = ShopCategory.all.length
        delete :destroy, :id => 0
      end
      
      it 'should redirect to #index' do
        response.should redirect_to(admin_shop_categories_path)
      end
      
      it 'should have a flash message' do
        flash.now[:notice].should == "Category could not be found."
      end
      
      it 'should have deleted the product' do
        ShopCategory.all.length.should == @length
      end
      
    end
    
    context 'product destroyed' do
      
      before :each do
        @length = ShopCategory.all.length
        delete :destroy, :id => @category.id
      end
      
      it 'should redirect to #index' do
        response.should redirect_to(admin_shop_categories_path)
      end
      
      it 'should have a flash message' do
        flash.now[:notice].should == "Category deleted successfully"
      end
      
      it 'should have deleted the category' do
        ShopCategory.all.length.should == (@length - 1)
      end
      
    end
    
  end
  
end