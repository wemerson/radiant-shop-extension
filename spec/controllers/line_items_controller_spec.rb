require 'spec/spec_helper'

describe Shop::LineItemsController do

  describe '#index' do
    before :each do
      @order = Object.new
      stub(@order).id.returns(rand(1000))

      @line_items = Object.new
      mock(controller).current_shop_order.mock!.line_items.mock!.all { @line_items }
    end

    it 'should list all items' do
      get :index, :order_id => @order.id
      response.should be_success
    end

    it 'should list all items in js' do
      get :index, :format => 'js', :order_id => @order.id
      response.should be_success
    end

    it 'should list all items in json' do
      mock(@line_items).to_json(is_a(Hash))
      get :index, :format => 'json', :order_id => @order.id
      response.should be_success
    end

    it 'should list all items in xml' do
      mock(@line_items).to_xml(is_a(Hash))
      get :index, :format => 'xml', :order_id => @order.id
      response.should be_success
    end
  end

  describe '#show' do
    before :each do
      @order = Object.new
      stub(@order).id.returns(rand(1000))

      @line_item = Object.new
      stub(@line_item).id.returns(rand(1000))

      @line_items = Object.new
      mock(controller).current_shop_order.mock!.line_items.mock!.find(@line_item.id.to_s) { @line_items }
    end

    it 'should list all items' do
      get :show, :order_id => @order.id, :id => @line_item.id
      response.should be_success
    end

    it 'should list all items in js' do
      get :show, :format => 'js', :order_id => @order.id, :id => @line_item.id
      response.should be_success
    end

    it 'should list all items in json' do
      mock(@line_items).to_json(is_a(Hash))
      get :show, :format => 'json', :order_id => @order.id, :id => @line_item.id
      response.should be_success
    end

    it 'should list all items in xml' do
      mock(@line_items).to_xml(is_a(Hash))
      get :show, :format => 'xml', :order_id => @order.id, :id => @line_item.id
      response.should be_success
    end
  end

  describe '#create' do
    before :each do
      @order = Object.new
      stub(@order).id.returns(rand(1000))

      @line_item = Object.new
      stub(@line_item).id.returns(rand(1000))
    end

    context 'success' do
      before :each do
        mock(controller).current_shop_order.mock!.add(nil, nil) { @line_item }
        mock(@line_item).errors.mock!.empty?.returns(true)
      end

      it 'should redirect back' do
        mock(controller).redirect_to :back
        post :create, :order_id => @order.id, :shop_line_item => {}
        response.should be_success
      end

      it 'should list all items in js' do
        mock(controller).render.with_any_args.twice
        post :create, :format => 'js', :order_id => @order.id, :shop_line_item => {}
        response.should be_success
      end

      it 'should list all items in json' do
        mock(controller).redirect_to "/shop/line_items/#{@line_item.id}.json"
        post :create, :format => 'json', :order_id => @order.id, :shop_line_item => {}
        response.should be_success
      end

      it 'should list all items in xml' do
        mock(controller).redirect_to "/shop/line_items/#{@line_item.id}.xml"
        post :create, :format => 'xml', :order_id => @order.id, :shop_line_item => {}
        response.should be_success
      end
    end

    context 'failure' do
      before :each do
        mock(controller).current_shop_order.mock!.add(nil, nil) { @line_item }
        mock(@line_item).errors.mock!.empty?
        mock(controller).render.with_any_args.twice
      end

      it 'should list all items' do
        post :create, :order_id => @order.id, :shop_line_item => {}
        response.should be_success
      end

      it 'should list all items in js' do
        mock(@line_item).errors.mock!.to_json
        post :create, :format => 'js', :order_id => @order.id, :shop_line_item => {}
        response.should be_success
      end

      it 'should list all items in json' do
        mock(@line_item).errors.mock!.to_json
        post :create, :format => 'json', :order_id => @order.id, :shop_line_item => {}
        response.should be_success
      end

      it 'should list all items in xml' do
        mock(@line_item).errors.mock!.to_xml
        post :create, :format => 'xml', :order_id => @order.id, :shop_line_item => {}
        response.should be_success
      end
    end
  end

  describe '#update' do
    before :each do
      @order = Object.new
      stub(@order).id.returns(rand(1000))

      @line_item = Object.new
      stub(@line_item).id.returns(rand(1000))
    end

    context 'success' do
      before :each do
        mock(controller).current_shop_order.mock!.update(nil, nil) { @line_item }
        mock(@line_item).errors.mock!.empty?.returns(true)
      end

      it 'should redirect back' do
        mock(controller).redirect_to :back
        put :update, :order_id => @order.id, :id => @line_item.id, :shop_line_item => {}
        response.should be_success
      end

      it 'should list all items in js' do
        mock(controller).render.with_any_args.twice
        put :update, :format => 'js', :order_id => @order.id, :id => @line_item.id, :shop_line_item => {}
        response.should be_success
      end

      it 'should list all items in json' do
        mock(controller).redirect_to "/shop/line_item/#{@line_item.id}.json"
        put :update, :format => 'json', :order_id => @order.id, :id => @line_item.id, :shop_line_item => {}
        response.should be_success
      end

      it 'should list all items in xml' do
        mock(controller).redirect_to "/shop/line_item/#{@line_item.id}.xml"
        put :update, :format => 'xml', :order_id => @order.id, :id => @line_item.id, :shop_line_item => {}
        response.should be_success
      end
    end

    context 'failure' do
      before :each do
        mock(controller).current_shop_order.mock!.update(nil, nil) { @line_item }
        mock(@line_item).errors.mock!.empty?
        mock(controller).render.with_any_args.twice
      end

      it 'should list all items' do
        put :update, :order_id => @order.id, :id => @line_item.id, :shop_line_item => {}
        response.should be_success
      end

      it 'should list all items in js' do
        mock(@line_item).errors.mock!.to_s
        put :update, :format => 'js', :order_id => @order.id, :id => @line_item.id, :shop_line_item => {}
        response.should be_success
      end

      it 'should list all items in json' do
        mock(@line_item).errors.mock!.to_json
        put :update, :format => 'json', :order_id => @order.id, :id => @line_item.id, :shop_line_item => {}
        response.should be_success
      end

      it 'should list all items in xml' do
        mock(@line_item).errors.mock!.to_xml
        put :update, :format => 'xml', :order_id => @order.id, :id => @line_item.id, :shop_line_item => {}
        response.should be_success
      end
    end
  end

  describe '#destroy' do
    before :each do
      @order = Object.new
      stub(@order).id.returns(rand(1000))

      @line_item = Object.new
      stub(@line_item).id.returns(rand(1000))
    end

    context 'success' do
      before :each do
        mock(controller).current_shop_order.mock!.remove(@line_item.id.to_s) { @line_item }
        mock(@line_item).destroyed?.returns(true)
      end

      it 'should redirect back' do
        mock(controller).redirect_to :back
        delete :destroy, :order_id => @order.id, :id => @line_item.id
        response.should be_success
      end

      it 'should list all items in js' do
        mock(controller).render.with_any_args.twice
        delete :destroy, :format => 'js', :order_id => @order.id, :id => @line_item.id
        response.should be_success
      end

      it 'should list all items in json' do
        mock(controller).render.with_any_args.twice
        delete :destroy, :format => 'json', :order_id => @order.id, :id => @line_item.id
        response.should be_success
      end

      it 'should list all items in xml' do
        mock(controller).render.with_any_args.twice
        delete :destroy, :format => 'xml', :order_id => @order.id, :id => @line_item.id
        response.should be_success
      end
    end

    context 'failure' do
      before :each do
        mock(controller).current_shop_order.mock!.remove(@line_item.id.to_s) { @line_item }
        mock(@line_item).destroyed?
        mock(controller).render.with_any_args.twice
      end

      it 'should list all items' do
        delete :destroy, :order_id => @order.id, :id => @line_item.id
        response.should be_success
      end

      it 'should list all items in js' do
        delete :destroy, :format => 'js', :order_id => @order.id, :id => @line_item.id
        response.should be_success
      end

      it 'should list all items in json' do
        delete :destroy, :format => 'json', :order_id => @order.id, :id => @line_item.id
        response.should be_success
      end

      it 'should list all items in xml' do
        delete :destroy, :format => 'xml', :order_id => @order.id, :id => @line_item.id
        response.should be_success
      end
    end
  end

end
