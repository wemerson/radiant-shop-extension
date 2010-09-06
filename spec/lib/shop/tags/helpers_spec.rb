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
    @shop_category = category
    @shop_categories = [ category, category, category ]
    
    product = Object.new
    @shop_product   = product
    @shop_products  = [ product, product, product ]
    
    stub(@shop_product).category { @shop_category }
    stub(@shop_category).products { @shop_products }    
  end
  
  describe '#current_categories(tag)' do
    context 'search query' do
      it 'should return matching categories' do
        stub(@page).params { {'query'=>'term'} }
        
        mock(ShopCategory).search('term') { @shop_categories }
        
        result = Shop::Tags::Helpers.current_categories(@tag)
        result.should == @shop_categories
      end
    end
    
    context 'all results' do
      it 'should return all categories' do
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
    context 'id' do
      it 'should return the matching category' do
        stub(@shop_category).id { 1 }
        @attrs['id'] = @shop_category.id
        
        mock(ShopCategory).find(@shop_category.id) { @shop_category }
        
        result = Shop::Tags::Helpers.current_category(@tag)
        result.should == @shop_category
      end
    end
    context 'handle' do
      it 'should return the matching category' do
        stub(@shop_category).handle { 'bob' }
        @attrs['handle'] = @shop_category.handle
        
        mock(ShopCategory).find(:first, {:conditions=>{:handle=>@shop_category.handle}}) { @shop_category }
        
        result = Shop::Tags::Helpers.current_category(@tag)
        result.should == @shop_category
      end
    end
    context 'name' do
      it 'should return the matching category' do
        stub(@shop_category).name { 'bob' }
        @attrs['name'] = @shop_category.name
        
        mock(ShopCategory).find(:first, {:conditions=>{:name=>@shop_category.name}}) { @shop_category }
        
        result = Shop::Tags::Helpers.current_category(@tag)
        result.should == @shop_category
      end
    end
    context 'position' do
      it 'should return the matching category' do
        stub(@shop_category).position { '10' }
        @attrs['position'] = @shop_category.position
        
        mock(ShopCategory).find(:first, {:conditions=>{:position=>@shop_category.position}}) { @shop_category }
        
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
        stub(@locals).shop_category { nil }
        stub(@locals).shop_product { @shop_product }
        
        result = Shop::Tags::Helpers.current_category(@tag)
        result.should == @shop_category
      end
    end
    context 'Using page slug' do
      it 'should return the matching category' do
        stub(@shop_category).handle { 'bob' }
        stub(@locals).shop_category { nil }
        stub(@locals).shop_product  { nil }
        stub(@page).slug { @shop_category.handle }
        
        mock(ShopCategory).find(:first, {:conditions=>{:handle=>@shop_category.handle}}) { @shop_category }
        
        result = Shop::Tags::Helpers.current_category(@tag)
        result.should == @shop_category
      end
    end
  end
  
  describe '#current_products(tag)' do
    context 'search query' do
      it 'should return matching products' do
        stub(@locals).page.stub!.params { {'query'=>'term'} }
        
        mock(ShopProduct).search('term') { @shop_products }
        
        result = Shop::Tags::Helpers.current_products(@tag)
        result.should == @shop_products
      end
    end
    context 'no query' do
      context 'current category' do
        it 'should return all products in that category' do
          stub(@locals).shop_category { @shop_category }
          stub(@page).params { { } }
          
          result = Shop::Tags::Helpers.current_products(@tag)
          result.should == @shop_category.products
        end
      end
      
      context 'all results' do
        it 'should return all products' do
          stub(@locals).shop_category     { nil }
          stub(@locals).page.stub!.params { {} }
          mock(ShopProduct).all { @shop_products }
          
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
    context 'id' do
      it 'should return the matching product' do
        stub(@shop_product).id { 1 }
        @attrs['id'] = @shop_product.id
        
        mock(ShopProduct).find(@shop_product.id) { @shop_product }
        
        result = Shop::Tags::Helpers.current_product(@tag)
        result.should == @shop_product
      end
    end
    context 'sku' do
      it 'should return the matching product' do
        stub(@shop_product).sku { 'bob' }
        @attrs['sku'] = @shop_product.sku
        
        mock(ShopProduct).find(:first, :conditions => { :sku => @shop_product.sku}) { @shop_product }
        
        result = Shop::Tags::Helpers.current_product(@tag)
        result.should == @shop_product
      end
    end
    context 'name' do
      it 'should return the matching product' do
        stub(@shop_product).name { 'bob' }
        @attrs['name'] = @shop_product.name
        
        mock(ShopProduct).find(:first, :conditions => { :name => @shop_product.name}) { @shop_product }
        
        result = Shop::Tags::Helpers.current_product(@tag)
        result.should == @shop_product
      end
    end
    context 'position' do
      it 'should return the matching product' do
        stub(@shop_product).position { '10' }
        @attrs['position'] = @shop_product.position
        
        mock(ShopProduct).find(:first, :conditions => { :position => @shop_product.position}) { @shop_product }
        
        result = Shop::Tags::Helpers.current_product(@tag)
        result.should == @shop_product
      end
    end
    context 'tag.locals.shop_product' do
      it 'should return the matching product' do
        stub(@locals).shop_product { @shop_product }
        
        result = Shop::Tags::Helpers.current_product(@tag)
        result.should == @shop_product
      end
    end
    context 'Using page slug' do
      it 'should return the matching category' do
        stub(@shop_product).sku { 'bob' }
        
        stub(@page).slug { @shop_product.sku }
        stub(@locals).shop_product { nil }
        
        mock(ShopProduct).find(:first, {:conditions=>{:sku=>@shop_product.sku}}) { @shop_product }
        
        result = Shop::Tags::Helpers.current_product(@tag)
        result.should == @shop_product
      end
    end
  end
  
end