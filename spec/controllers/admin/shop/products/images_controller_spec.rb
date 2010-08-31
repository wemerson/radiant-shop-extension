require 'spec/spec_helper'

describe Admin::Shop::Products::ImagesController do
  
  dataset :users
    
  before(:each) do
    login_as  :admin
    
    @shop_product = Object.new
    stub(@shop_product).id { 1 }
    mock(ShopProduct).find('1') { @shop_product }
        
    @image = Object.new
    @images = [ @image ]
  end
  
  describe '#index' do
    
    context 'product has no images' do
      before :each do
        stub(@shop_product).images { [] }
      end
      
      context 'html' do
        before :each do
          get :index, :product_id => 1
        end
        
        it 'should redirect to edit_shop path' do
          response.should redirect_to(edit_admin_shop_product_path(@shop_product))
        end
        
        it 'should assign a flash error' do
          flash.now[:error].should_not be_nil
        end
      end
      
      context 'js' do
        before :each do
          get :index, :product_id => 1, :format => 'js'
        end

        it 'should return unprocessable status' do
          response.should_not be_success
        end
        
        it 'should redirect to edit_shop path' do
          response.body.should == 'This Product has no Images.'
        end
      end
      
      context 'json' do
        before :each do
          get :index, :product_id => 1, :format => 'json'
        end
        
        it 'should return unprocessable status' do
          response.should_not be_success
        end
        
        it 'should return a json object with an erorr message' do
          JSON.parse(response.body)['error'].should == 'This Product has no Images.'
        end
      end
    end
    
    context 'product has images' do
      before :each do
        stub(@shop_product).images { @images }
      end
      
      context 'html' do
        before :each do
          get :index, :product_id => 1
        end
        
        it 'should assign the shop_product_images instance variable' do
          assigns(:shop_product_images).should == @images
        end
        
        it 'should redirect to edit_shop path' do
          response.should redirect_to(edit_admin_shop_product_path(@shop_product))
        end
        
        it 'should not assign a flash error' do
          flash.now[:error].should be_nil
        end
      end
      
      context 'js' do
        before :each do
          get :index, :product_id => 1, :format => 'js'
        end
        
        it 'should return success' do
          response.should be_success
        end
        
        it 'should assign the shop_product_images instance variable' do
          assigns(:shop_product_images).should == @images
        end
        
        it 'should render the collection partial' do
          response.should render_template('/admin/shop/products/images/_image')
        end
      end
      
      context 'json' do
        before :each do
          get :index, :product_id => 1, :format => 'json'
        end
        
        it 'should return success' do
          response.should be_success
        end
        
        it 'should return a json object of the array' do
          response.body.should == @images.to_json(ShopProductAttachment.params)
        end
      end
    end
  end
  
  describe '#sort' do
    before :each do
      @attachments = [
        'product_attachments[]=2',
        'product_attachments[]=1'
      ].join('&')
    end
    
    context 'could not sort' do
      before :each do
        stub(@shop_product).attachments.stub!.find('2').stub!.update_attribute('position',1) { raise 'No Sorting' }
        stub(@shop_product).images { @images }
      end
      
      context 'html' do
        before :each do
          put :sort, :product_id => 1, :attachments => @attachments
        end
        
        it 'should assign a flash notice' do
          flash.now[:error].should_not be_nil
        end
        
        it 'should redirect to product edit' do
          response.should redirect_to(edit_admin_shop_product_path(@shop_product))
        end
      end
      
      context 'js' do
        before :each do
          put :sort, :product_id => 1, :attachments => @attachments, :format => 'js'
        end
        
        it 'should return unprocessable status' do
          response.should_not be_success
        end
        
        it 'should return an error string' do
          response.body.should == 'Could not sort Images.'
        end
      end
      
      context 'json' do
        before :each do
          put :sort, :product_id => 1, :attachments => @attachments, :format => 'json'
        end
        
        it 'should return unprocessable status' do
          response.should_not be_success
        end
        
        it 'should return a json object with an erorr message' do
          JSON.parse(response.body)['error'].should == 'Could not sort Images.'
        end
      end
    end
    
    context 'successfully sorted' do 
      before :each do
        stub(@shop_product).attachments.stub!.find(anything).stub!.update_attribute('position',anything) { true }
        stub(@shop_product).images { @images }
      end
      
      context 'html' do
        before :each do
          put :sort, :product_id => 1, :attachments => @attachments
        end
        
        it 'should assign a flash notice' do
          flash.now[:notice].should_not be_nil
        end
        
        it 'should have ordered the images based on input' do
          assigns(:images).first.should == '2'
          assigns(:images).last.should == '1'
        end
        
        it 'should redirect to product edit' do
          response.should redirect_to(edit_admin_shop_product_path(@shop_product))
        end
      end
      
      context 'js' do
        before :each do
          put :sort, :product_id => 1, :attachments => @attachments, :format => 'js'
        end
        
        it 'should return success' do
          response.should be_success
        end
        
        it 'should render the collection partial' do
          response.should render_template('/admin/shop/products/images/_image')
        end
      end
      
      context 'json' do
        before :each do
          put :sort, :product_id => 1, :attachments => @attachments, :format => 'json'
        end
        
        it 'should return success' do
          response.should be_success
        end
        
        it 'should return a json object of the array' do
          response.body.should == @images.to_json(ShopProductAttachment.params)
        end
      end
    end
  end
  
  describe '#create' do
    context 'new image' do
      context 'could not create image' do
        before :each do
          mock(Image).create!('FileObject') { raise 'Could not create' }
        end
        
        context 'html' do
          before :each do
            post :create, :product_id => 1, :image => 'FileObject'
          end
          
          it 'should assign a flash error' do
            flash.now[:error].should_not be_nil
          end
          
          it 'should redirect to edit_shop_product path' do
            response.should redirect_to(edit_admin_shop_product_path(@shop_product))
          end
        end
        
        context 'js' do
          before :each do
            post :create, :product_id => 1, :image => 'FileObject', :format => 'js'
          end
          
          it 'should return unprocessable status' do
            response.should_not be_success
          end
          
          it 'should return an error string' do
            response.body.should == 'Unable to create Image.'
          end
        end
        
        context 'json' do
          before :each do
            post :create, :product_id => 1, :image => 'FileObject', :format => 'json'
          end
          
          it 'should return unprocessable status' do
            response.should_not be_success
          end
          
          it 'should return a json object with an erorr message' do
            JSON.parse(response.body)['error'].should == 'Unable to create Image.'
          end
        end
        
      end
      
      context 'successfully created image' do
        before :each do
          mock(Image).create!('FileObject') { @image }
        end
        
        context 'could not create attachment' do
          
        end
        
        context 'successfully created attachment' do
          
        end
      end
    end
    
    context 'existing image' do
      context 'could not create attachment' do
        
      end
      
      context 'successfully created attachment' do
        
      end
    end
  end
  
  describe '#destroy' do
    
  end
  
end
