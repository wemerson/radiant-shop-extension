require 'spec/spec_helper'

describe Shop::Tags::Helpers do
  
  dataset :pages
  
  before :all do
    @page = pages(:home)
  end
  
  before(:each) do
    @locals = Object.new
    stub(@locals).page { @page }
    
    @attrs  = {}
    
    @tag = Object.new
    stub(@tag).attr   { @attrs }
    stub(@tag).locals { @locals }
    
    category = Object.new
    @shop_category    = category
    @shop_categories  = [ @shop_category, @shop_category, @shop_category ]
    
    product = Object.new
    @shop_product   = product
    @shop_products  = [ @shop_product, @shop_product, @shop_product ]
    
    order = Object.new
    @shop_order = order
    
    item = Object.new
    @shop_line_item   = item
    @shop_line_items  = [ @shop_line_item, @shop_line_item, @shop_line_item ]
    
    stub(@shop_product).category  { @shop_category }
    stub(@shop_category).products { @shop_products }
    stub(@shop_line_item).product { @shop_product }
    stub(@shop_order).line_items  { @shop_line_items }
  end
  
  describe '#current_categories(tag)' do
    context 'search query' do
      it 'should return matching categories' do
        stub(@locals).shop_categories { [] }
        stub(@page).params { {'query'=>'term'} }
        
        mock(ShopCategory).search('term') { @shop_categories }
        
        result = Shop::Tags::Helpers.current_categories(@tag)
        result.should == @shop_categories
      end
    end
    
    context 'key => value' do
      it 'should return matching categories' do
        stub(@locals).shop_categories { [] }
        stub(@page).params { {} }
        @attrs['key'] = 'find'
        @attrs['value'] = 'me'
        
        mock(ShopCategory).all(:conditions => { :find => 'me' }) { @shop_categories }
        
        result = Shop::Tags::Helpers.current_categories(@tag)
        result.should == @shop_categories
      end
    end
    
    context 'all results' do
      it 'should return all categories' do
        stub(@locals).shop_categories { [] }
        stub(@page).params { {} }
        
        mock(ShopCategory).all { @shop_categories }
        
        result = Shop::Tags::Helpers.current_categories(@tag)
        result.should == @shop_categories
      end
    end
  end
  
  describe '#current_category(tag)' do
    context 'parameters' do
      it 'should be calling an object with those attributes' do
        object = ShopCategory.new
        object.attributes.include?('handle').should == true
        object.attributes.include?('name').should == true
        object.attributes.include?('position').should == true
      end
    end
    context 'key => value' do
      it 'should return the matching category' do
        stub(@locals).shop_category { nil }
        @attrs['key'] = 'find'
        @attrs['value'] = 'me'
        
        mock(ShopCategory).first(:conditions => { :find => 'me' }) { @shop_category }
        
        result = Shop::Tags::Helpers.current_category(@tag)
        result.should == @shop_category
      end
    end
    context 'tag.locals.page.shop_category' do
      it 'should return the matching category' do
        stub(@locals).shop_category { @shop_category }
        
        result = Shop::Tags::Helpers.current_category(@tag)
        result.should == @shop_category
      end
    end
    context 'tag.locals.page.shop_product' do
      it 'should return the matching category' do
        stub(@locals).shop_category { nil }
        stub(@page).shop_product    { @shop_product }
        
        result = Shop::Tags::Helpers.current_category(@tag)
        result.should == @shop_category
      end
    end
    context 'tag.locals.shop_category' do
      it 'should return the matching category' do
        stub(@locals).shop_category { @shop_category }
        
        result = Shop::Tags::Helpers.current_category(@tag)
        result.should == @shop_category
      end
    end
    context 'tag.locals.shop_product' do
      it 'should return the matching category' do
        stub(@page).shop_category   { nil }
        stub(@page).shop_product    { nil }
        stub(@locals).shop_category { nil }
        stub(@locals).shop_product  { @shop_product }
        
        result = Shop::Tags::Helpers.current_category(@tag)
        result.should == @shop_category
      end
    end
    context 'Using page slug' do
      it 'should return the matching category' do
        stub(@shop_category).handle { 'bob' }
        stub(@page).shop_category   { nil }
        stub(@page).shop_product    { nil }
        stub(@locals).shop_category { nil }
        stub(@locals).shop_product  { nil }
        stub(@page).slug            { @shop_category.handle }
        
        mock(ShopCategory).find(:first, {:conditions=>{:handle=>@shop_category.handle}}) { @shop_category }
        
        result = Shop::Tags::Helpers.current_category(@tag)
        result.should == @shop_category
      end
    end
  end
  
  describe '#current_products(tag)' do
    context 'tag.locals.shop_products' do
      it 'should return matching products' do
        stub(@locals).shop_products { @shop_products }
        
        result = Shop::Tags::Helpers.current_products(@tag)
        result.should == @shop_products
      end
    end
    context 'search query' do
      it 'should return matching products' do
        stub(@locals).shop_products { [] }
        stub(@page).params { {'query'=>'term'} }
        
        mock(ShopProduct).search('term') { @shop_products }
        
        result = Shop::Tags::Helpers.current_products(@tag)
        result.should == @shop_products
      end
    end
    context 'key => value' do
      it 'should return the matching products' do
        stub(@locals).shop_products { [] }
        stub(@page).params { {} }
        @attrs['key'] = 'find'
        @attrs['value'] = 'me'
        
        mock(ShopProduct).all(:conditions => { :find => 'me' }) { @shop_products }
        
        result = Shop::Tags::Helpers.current_products(@tag)
        result.should == @shop_products
      end
    end
    context 'no query' do
      context 'tag.locals.page.shop_category' do
        it 'should return all products in that category' do
          stub(@page).params          { { } }
          stub(@locals).shop_products { [] }
          stub(@page).shop_category   { @shop_category }
          
          result = Shop::Tags::Helpers.current_products(@tag)
          result.should == @shop_category.products
        end
      end
      
      context 'tag.locals.shop_category' do
        it 'should return all products in that category' do
          stub(@locals).shop_products { [] }
          stub(@page).params          { { } }
          stub(@page).shop_category   { nil }
          stub(@locals).shop_category { @shop_category }
          
          result = Shop::Tags::Helpers.current_products(@tag)
          result.should == @shop_category.products
        end
      end
      
      context 'all results' do
        it 'should return all products' do
          stub(@page).params            { {} }
          stub(@locals).shop_products   { {} }
          stub(@page).shop_category     { nil }
          stub(@locals).shop_category   { nil }
          mock(ShopProduct).all         { @shop_products }
          
          result = Shop::Tags::Helpers.current_products(@tag)
          result.should == @shop_products
        end
      end
    end
  end
  
  describe '#current_product(tag)' do
    context 'parameters' do
      it 'should be calling an object with those attributes' do
        object = ShopProduct.new
        object.attributes.include?('sku').should == true
        object.attributes.include?('name').should == true
        object.attributes.include?('position').should == true
      end
    end
    context 'key => value' do
      it 'should return the matching product' do
        stub(@locals).shop_product { nil }
        @attrs['key'] = 'find'
        @attrs['value'] = 'me'
        
        mock(ShopProduct).first(:conditions => { :find => 'me' }) { @shop_product }
        
        result = Shop::Tags::Helpers.current_product(@tag)
        result.should == @shop_product
      end
    end
    context 'tag.locals.page.shop_product' do
      it 'should return the matching product' do
        stub(@locals).shop_product  { nil }
        stub(@page).shop_product    { @shop_product }
        
        result = Shop::Tags::Helpers.current_product(@tag)
        result.should == @shop_product
      end
    end
    context 'tag.locals.shop_product' do
      it 'should return the matching product' do
        stub(@locals).shop_product  { @shop_product }
        
        result = Shop::Tags::Helpers.current_product(@tag)
        result.should == @shop_product
      end
    end
    context 'Using page slug' do
      it 'should return the matching category' do
        stub(@shop_product).sku     { 'bob' }
        
        stub(@page).shop_product    { nil }
        stub(@locals).shop_product  { nil }
        stub(@page).slug            { @shop_product.sku }
                
        mock(ShopProduct).find(:first, {:conditions=>{:sku=>@shop_product.sku}}) { @shop_product }
        
        result = Shop::Tags::Helpers.current_product(@tag)
        result.should == @shop_product
      end
    end
  end
  
  describe '#current_order(tag)' do
    context 'existing order' do
      it 'should return the order' do
        stub(@locals).shop_order { @shop_order }
        
        result = Shop::Tags::Helpers.current_order(@tag)
        result.should == @shop_order
      end
    end
    context 'using order id' do
      it 'should return the order' do
        stub(@locals).shop_order { nil }
        stub(@shop_order).id { 1 }
        mock(ShopOrder).find(@shop_order.id) { @shop_order }
        
        @attrs['id'] = @shop_order.id
        
        result = Shop::Tags::Helpers.current_order(@tag)
        result.should == @shop_order
      end
    end
    context 'using request object' do
      it 'should return the order' do
        stub(@locals).shop_order { nil }
        stub(@shop_order).id { 1 }
        stub(@page).request.stub!.session { { :shop_order => @shop_order.id  } }
        
        mock(ShopOrder).find(@shop_order.id) { @shop_order }
        
        result = Shop::Tags::Helpers.current_order(@tag)
        result.should == @shop_order
      end
    end
  end
  
  describe '#current_line_item(tag)' do
    context 'existing line item' do
      it 'should return the line item' do
        stub(@locals).shop_line_item { @shop_line_item }
        
        result = Shop::Tags::Helpers.current_line_item(@tag)
        result.should == @shop_line_item
      end
    end
    context 'existing line item' do
      it 'using the current item' do
        stub(@shop_product).id { 1 }
        
        stub(@locals).shop_line_item  { nil }
        stub(@locals).shop_order      { @shop_order }
        stub(@locals).shop_product    { @shop_product }
        
        mock(@shop_line_items).find_by_item_id(@shop_product.id) { @shop_line_item }
        
        result = Shop::Tags::Helpers.current_line_item(@tag)
        result.should == @shop_line_item
      end
    end
  end
  
  describe '#current_address(tag)' do
    context 'address exists' do
      it 'should return that billing address' do
        @billing = Object.new
        
        stub(@shop_order).billing { @billing }
        stub(@locals).shop_order { @shop_order }
        
        @attrs['type'] = 'billing'
        
        result = Shop::Tags::Helpers.current_address(@tag)
        result.should == @billing
      end
    end
    context 'address does not exist' do
      it 'should return nil' do
        stub(@shop_order).billing { nil }
        stub(@locals).shop_order { @shop_order }
        
        @attrs['type'] = 'billing'
        
        result = Shop::Tags::Helpers.current_address(@tag)
        result.should == nil
      end
    end
  end
  
end