require 'spec/spec_helper'

describe Shop::LineItemsController do
  before :each do
    request.env["HTTP_REFERER"] = '/back'

    @order = Object.new
    stub(@order).id { '1' }
    
    @line_item = Object.new
    stub(@line_item).id { '1' }
    
    @attr_hash = { 
      :include  => :product,
      :only     => ShopLineItem.params
    }
  end
  
  describe '#index' do
    before :each do
      @line_items = Object.new
      mock(controller).find_or_create_shop_order.mock!.line_items.mock!.all { @line_items }
    end
    
    it 'should list all items' do
      get :index
      response.should be_success
      response.should render_template(:index)
    end
    
    it 'should list all items in js' do
      get :index, :format => 'js'
      response.should be_success
      response.should render_template('/shop/line_items/_line_item')
    end
    
    it 'should list all items in json' do
      get :index, :format => 'json'
      response.should be_success
      response.body.should == @line_items.to_json(@attr_hash)
    end
  end
  
  describe '#show' do
    before :each do
      @line_items = Object.new
      mock(controller).find_or_create_shop_order.mock!.line_items.mock!.find(@line_item.id.to_s) { @line_items }
    end
    
    it 'should list all items' do
      get :show, :id => @line_item.id
      response.should be_success
      response.should render_template(:show)
    end
    
    it 'should list all items in js' do
      get :show, :format => 'js', :id => @line_item.id
      response.should be_success
      response.should render_template('/shop/line_items/_line_item')
    end
    
    it 'should list all items in json' do
      get :show, :format => 'json', :id => @line_item.id
      response.should be_success
      response.body.should == @line_item.to_json(@attr_hash)
    end
  end
  
  describe '#create' do
    context 'success' do
      context 'defined quantity' do
        it 'should assign the custom quantity' do
          mock(controller).find_or_create_shop_order.mock!.add!(1, 5, nil) { @line_item }
          
          post :create, :line_item => { :item_id => 1, :quantity => 5 }
        end
      end
      context 'no quantity defined' do
        it 'should assign a quantity of 1' do
          mock(controller).find_or_create_shop_order.mock!.add!(1, nil, nil) { @line_item }
          
          post :create, :line_item => { :item_id => 1}
        end
      end
      context 'defined type' do
        it 'should redirect back' do
          mock(controller).find_or_create_shop_order.mock!.add!(1, nil, 'ShopPackage') { @line_item }
          
          post :create, :line_item => { :item_id => 1, :item_type => 'ShopPackage' }
        end
      end
      context 'no type defined' do
        it 'should not assign a type and redirect back' do
          mock(controller).find_or_create_shop_order.mock!.add!(1, nil, nil) { @line_item }
          
          post :create, :line_item => { :item_id => 1 }
        end
      end
      
      context 'responses' do
        before :each do
          mock(controller).find_or_create_shop_order.mock!.add!(1, nil, nil) { @line_item }
        end
        it 'HTML should assign a notice and redirect' do
          post :create, :line_item => { :item_id => 1 }
          
          flash.now[:notice] === 'Item added to Cart.'
          response.should redirect_to('/back')
        end
        it 'JS should list all items in' do
          post :create, :line_item => { :item_id => 1 }, :format => 'js'
          
          response.should be_success
          response.should render_template('/shop/line_items/_line_item')
        end
      
        it 'JSON should list all items in' do
          post :create, :line_item => { :item_id => 1 }, :format => 'json'
          
          response.should be_success
          response.body.should === @line_item.to_json(@attr_hash)
        end
      end
    end
    
    context 'failure' do
      before :each do
        mock(controller).find_or_create_shop_order.mock!.add!(1, 1, nil) { raise ActiveRecord::RecordNotSaved }
      end
      it 'should list all items' do
        post :create, :line_item => { :item_id => 1, :quantity => 1 }
        
        flash.now[:error].should === 'Could not add Item to Cart.'
        response.should redirect_to('/back')
      end
      
      it 'should list all items in js' do
        post :create, :line_item => { :item_id => 1, :quantity => 1 }, :format => 'js'
        
        response.should_not be_success
        response.body.should === 'Could not add Item to Cart.'  
      end
      
      it 'should list all items in json' do
        post :create, :line_item => { :item_id => 1, :quantity => 1 }, :format => 'json'
        
        response.should_not be_success
        JSON.parse(response.body)['error'].should === 'Could not add Item to Cart.'
      end
    end
  end
  
  describe '#update' do
    context 'success' do
      before :each do
        mock(controller).find_or_create_shop_order.mock!.update!(@line_item.id, 1) { @line_item }
      end
      
      it 'should redirect back' do
        put :update, :id => 'x', :line_item => { :id => @line_item.id }
        
        flash.now[:notice].should === 'Item updated successfully.'
        response.should redirect_to('/back')
      end
      
      it 'should list all items in js' do
        put :update, :id => 'x', :line_item => { :id => @line_item.id }, :format => 'js'
        
        response.should be_success
        response.should render_template('/shop/line_items/_line_item')
      end
      
      it 'should list all items in json' do
        put :update, :id => 'x', :line_item => { :id => @line_item.id }, :format => 'json'
        
        response.should be_success
        response.body.should === @line_item.to_json(@attr_hash)
      end
    end

    context 'failure' do
      before :each do
        mock(controller).find_or_create_shop_order.mock!.update!(@line_item.id, 1) { raise ActiveRecord::RecordNotSaved }
      end
      
      it 'HTML should list all items' do
        put :update, :id => 'x', :line_item => { :id => @line_item.id }
        flash.now[:error].should === 'Could not update Item.'
        response.should redirect_to('/back')
      end
      
      it 'JS should list all items' do
        put :update, :id => 'x', :line_item => { :id => @line_item.id }, :format => 'js'
        response.should_not be_success
        response.body.should === 'Could not update Item.'
      end
      
      it 'JSON should list all items' do
        put :update, :id => 'x', :line_item => { :id => @line_item.id }, :format => 'json'
        response.should_not be_success
        JSON.parse(response.body)['error'].should === 'Could not update Item.'
      end
    end
  end

  describe '#destroy' do  
    context 'success' do
      before :each do
        mock(controller).find_or_create_shop_order.mock!.remove!(@line_item.id) { true }
      end
      
      it 'should redirect back' do
        delete :destroy, :id => @line_item.id
        flash.now[:notice].should === 'Item removed from Cart.'
        response.should redirect_to('/back')
      end
      
      it 'should list all items in js' do
        delete :destroy, :id => @line_item.id, :format => 'js'
        response.should be_success
        response.body.should === 'Item removed from Cart.'
      end
      
      it 'should list all items in json' do
        delete :destroy, :id => @line_item.id, :format => 'json'
        response.should be_success
        JSON.parse(response.body)['notice'].should === 'Item removed from Cart.'
      end
    end
    
    context 'failure' do
      before :each do
        mock(controller).find_or_create_shop_order.mock!.remove!(@line_item.id.to_s) { raise ActiveRecord::RecordNotFound }
      end
      
      it 'should list all items' do
        delete :destroy, :id => @line_item.id
        flash.now[:error].should === 'Could not remove Item from Cart.'
        response.should redirect_to('/back')
      end
      
      it 'should list all items in js' do
        delete :destroy, :format => 'js', :id => @line_item.id
        response.should_not be_success
        response.body.should === 'Could not remove Item from Cart.'
      end
      
      it 'should list all items in json' do
        delete :destroy, :format => 'json', :id => @line_item.id
        response.should_not be_success
        JSON.parse(response.body)['error'].should === 'Could not remove Item from Cart.'
      end
    end
  end

end
