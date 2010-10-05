require 'spec/spec_helper'

describe Shop::Tags::Helpers do
  
  dataset :pages, :shop_products, :shop_orders, :shop_addresses, :shop_line_items
  
  before :all do
    @page = pages(:home)
  end
  
  before(:each) do
    @tag = OpenStruct.new({
      :attr   => {},
      :locals => OpenStruct.new({
        :page => OpenStruct.new({
          :params   => {},
          :request  => OpenStruct.new({
            :session => {}
          })
        })
      })
    })
  end
  
  describe '#current_categories' do
    before :each do
      @category   = shop_categories(:bread)
    end
    
    context 'categories previously set' do
      before :each do
        @tag.locals.shop_categories = [@category]
      end
      it 'should return categories' do
        result = Shop::Tags::Helpers.current_categories(@tag)
        result.should == [@category]
      end
    end
    
    context 'search query sent to page' do
      before :each do
        @tag.locals.page.params = { 'query' => @category.handle }
      end
      it 'should return matching categories' do
        result = Shop::Tags::Helpers.current_categories(@tag)
        result.should == [@category]
      end
    end
    
    context 'key and value sent' do
      before :each do
        @tag.attr = { 'key' => 'handle', 'value' => @category.handle }
      end
      it 'should return the matching categories' do
        result = Shop::Tags::Helpers.current_categories(@tag)
        result.should == [@category]
      end
    end
    
    context 'nothing additional sent' do
      before :each do
        mock(ShopCategory).all { [@category] }
      end
      it 'should return all categories in the database' do
        result = Shop::Tags::Helpers.current_categories(@tag)
        result.should == [@category]
      end
    end
  end
  
  describe '#current_category' do
    before :each do
      @category = shop_categories(:bread)
      @product  = shop_categories(:bread).products.first
    end
    
    context 'category previously set' do
      before :each do
        @tag.locals.shop_category = @category
      end
      it 'should return the existing category' do
        result = Shop::Tags::Helpers.current_category(@tag)
        result.should == @category
      end
    end
    
    context 'product previously set' do
      before :each do
        @tag.locals.shop_product = @product
      end
      it 'should return the category of the product attached to the page' do
        result = Shop::Tags::Helpers.current_category(@tag)
        result.should == @category
      end
    end

    context 'key and value sent' do
      before :each do
        @tag.attr = { 'key' => 'handle', 'value' => @category.handle }
      end
      it 'should return the matching categories' do
        result = Shop::Tags::Helpers.current_category(@tag)
        result.should == @category
      end
    end
    
    context 'the current page has a product attached to it' do
      before :each do
        @tag.locals.page.shop_product = @product
      end
      it 'should return the category of the product attached to the page' do
        result = Shop::Tags::Helpers.current_category(@tag)
        result.should == @category
      end
    end
    
    context 'the current page slug matches the category handle' do
      before :each do
        @tag.locals.page.slug = @category.handle
      end
      it 'should return the category with that handle' do
        result = Shop::Tags::Helpers.current_category(@tag)
        result.should == @category
      end
    end
    
    context 'the current page has a category attached to it' do
      before :each do
        @tag.locals.page.shop_category = @category
      end
      it 'should return the category attached to the page' do
        result = Shop::Tags::Helpers.current_category(@tag)
        result.should == @category
      end
    end
    
    context 'nothing available to find the category' do
      it 'should return nil' do
        result = Shop::Tags::Helpers.current_category(@tag)
        result.should be_nil
      end
    end
    
  end
    
  describe '#current_products' do
    before :each do
      @product  = shop_products(:soft_bread)
      @category = shop_categories(:bread)
    end

    context 'products previously set' do
      before :each do
        @tag.locals.shop_products = [ @product ]
      end
      it 'should return the existing categories' do
        result = Shop::Tags::Helpers.current_products(@tag)
        result.should == [@product]
      end
    end
    
    context 'category previously set' do
      before :each do
        @tag.locals.shop_category = @category
      end
      it 'should return the categorys products' do
        result = Shop::Tags::Helpers.current_products(@tag)
        result.should == @category.products
      end
    end
    
    context 'the current page has a category attached to it' do
      before :each do
        @tag.locals.page.shop_category = @category
      end
      it 'should return the products of the category attached to the page' do
        result = Shop::Tags::Helpers.current_products(@tag)
        result.should == @category.products
      end
    end
    
    context 'search query sent to page' do
      before :each do
        @tag.locals.page.params = { 'query' => @product.sku }
      end
      it 'should return matching products' do
        result = Shop::Tags::Helpers.current_products(@tag)
        result.should == [@product]
      end
    end
    
    context 'key and value sent' do
      before :each do
        @tag.attr = { 'key' => 'sku', 'value' => @product.sku }
      end
      it 'should return the matching products' do
        result = Shop::Tags::Helpers.current_products(@tag)
        result.should == [@product]
      end
    end
    
    context 'nothing additional sent' do
      before :each do
        mock(ShopProduct).all { [@product] }
      end
      it 'should return all products in the database' do
        result = Shop::Tags::Helpers.current_products(@tag)
        result.should == [@product]
      end
    end
  end
  
  describe '#current_product' do
    before :each do
      @product    = shop_products(:soft_bread)
      @line_item  = shop_line_items(:one)
    end
    
    context 'product previously set' do
      before :each do
        @tag.locals.shop_product = @product
      end
      it 'should return the product in that context' do
        result = Shop::Tags::Helpers.current_product(@tag)
        result.should == @product
      end
    end
    
    context 'line item previously set' do
      context 'for product' do
        before :each do
          @tag.locals.shop_line_item = @line_item
        end
        it 'should return the product of the line item' do
          result = Shop::Tags::Helpers.current_product(@tag)
          result.should == @line_item.item
        end
      end
      context 'not for product' do
        before :each do
          @line_item.item_type = 'ShopOther'
          @tag.locals.shop_line_item = @line_item
        end
        it 'should not return the product' do
          result = Shop::Tags::Helpers.current_product(@tag)
          result.should be_nil
        end
      end
    end

    context 'key and value sent' do
      before :each do
        @tag.attr = { 'key' => 'sku', 'value' => @product.sku }
      end
      it 'should return the matching categories' do
        result = Shop::Tags::Helpers.current_product(@tag)
        result.should == @product
      end
    end
    
    context 'the current page has a product attached to it' do
      before :each do
        @tag.locals.page.shop_product = @product
      end
      it 'should return the product attached to the page' do
        result = Shop::Tags::Helpers.current_product(@tag)
        result.should == @product
      end
    end
    
  end
  
  describe '#current_order' do
    before :each do
      @order = shop_orders(:one_item)
    end
    
    context 'order previously set' do
      before :each do
        @tag.locals.shop_order = @order
      end
      it 'should return the order' do
        result = Shop::Tags::Helpers.current_order(@tag)
        result.should == @order
      end
    end
    
    context 'key and value sent' do
      before :each do
        @tag.attr = { 'key' => 'id', 'value' => @order.id }
      end
      it 'should return the matching order' do
        result = Shop::Tags::Helpers.current_order(@tag)
        result.should == @order
      end
    end
    
    context 'session contains the order id' do
      before :each do
        @tag.locals.page.request.session[:shop_order] = @order.id
      end
      it 'should return the order with that id' do
        result = Shop::Tags::Helpers.current_order(@tag)
        result.should == @order
      end
    end
    
    context 'nothing available to find the product' do
      it 'should return nil' do
        result = Shop::Tags::Helpers.current_order(@tag)
        result.should be_nil
      end
    end
    
  end
  
  describe '#current_line_items' do
    before :each do
      @order = shop_orders(:several_items)
      @tag.locals.shop_order = @order
    end
    
    context 'line items previously set' do
      before :each do
        @tag.locals.shop_line_items = [@order.line_items.first]
      end
      it 'should return the order' do
        result = Shop::Tags::Helpers.current_line_items(@tag)
        result.should == [@order.line_items.first]
      end
    end
    
    context 'key and value sent' do
      before :each do
        @tag.attr = { 'key' => 'id', 'value' => @order.line_items.first.id }
      end
      it 'should return the matching order' do
        result = Shop::Tags::Helpers.current_line_items(@tag)
        result.should == [@order.line_items.first]
      end
    end
    
    context 'nothing available to find the items' do
      it 'should return the current orders items' do
        result = Shop::Tags::Helpers.current_line_items(@tag)
        result.should == @order.line_items
      end
    end
    
  end
  
  describe '#current_line_item' do
    before :each do
      @item = shop_line_items(:one)
    end
    
    context 'existing line item' do
      before :each do
        @tag.locals.shop_line_item = @item
      end
      it 'should return that existing line item' do
        result = Shop::Tags::Helpers.current_line_item(@tag)
        result.should == @item
      end
    end
    
    context 'existing product and category' do
      before :each do
        @tag.locals.shop_order = shop_orders(:one_item)
        @tag.locals.shop_product = shop_products(:crusty_bread)
      end
      it 'should return the item linking the two' do
        result = Shop::Tags::Helpers.current_line_item(@tag)
        result.should == @item
      end
    end
  end
  
  describe '#current_address' do
    before :each do
      @address  = shop_addresses(:billing)
      @tag.attr = { 'type' => 'billing' }
    end
    
    context 'billing address already exists and billing type was requested' do
      before :each do
        @tag.locals.address = @address
        @tag.locals.address_type = 'billing'
      end
      it 'should return the existing address' do
        result = Shop::Tags::Helpers.current_address(@tag)
        result.should == @address
      end
    end
    
    context 'current_order exists and has billing' do
      before :each do
        @order = shop_orders(:one_item)
        @order.update_attribute(:billing, @address)
        @tag.locals.shop_order = @order
      end
      it 'should return the order billing address' do
        result = Shop::Tags::Helpers.current_address(@tag)
        result.should == @address
      end
    end
    
    context 'current order exists and doesnt have billing' do
      before :each do
        @order = shop_orders(:one_item)
      end
      it 'should return nil' do
        result = Shop::Tags::Helpers.current_address(@tag)
        result.should be_nil
      end
    end
    
    context 'no order exists' do
      it 'should return nil' do
        result = Shop::Tags::Helpers.current_address(@tag)
        result.should be_nil
      end
    end
  end
  
end