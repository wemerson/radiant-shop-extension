require 'spec/spec_helper'

describe Shop::Tags::Helpers do
  
  before(:each) do
    tag = Object.new
    stub(tag).attr { {} }
    @tag = tag
    
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
        stub(@tag).locals.stub!.page.stub!.params { {'query'=>'term'} }

        mock(ShopCategory).search('term') { @shop_categories }
        
        result = Shop::Tags::Helpers.current_categories(@tag)
        result.should == @shop_categories
      end
    end
    
    context 'all results' do
      it 'should return all categories' do
        stub(@tag).locals.stub!.page.stub!.params { {} }
        
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
        stub(@tag).attr { { 'id' => @shop_category.id } }
        
        mock(ShopCategory).find(@shop_category.id) { @shop_category }
        
        result = Shop::Tags::Helpers.current_category(@tag)
        result.should == @shop_category
      end
    end
    context 'handle' do
      it 'should return the matching category' do
        stub(@shop_category).handle { 'bob' }
        stub(@tag).attr { { 'handle' => @shop_category.handle } }
        
        mock(ShopCategory).find(:first, {:conditions=>{:handle=>@shop_category.handle}}) { @shop_category }
        
        result = Shop::Tags::Helpers.current_category(@tag)
        result.should == @shop_category
      end
    end
    context 'name' do
      it 'should return the matching category' do
        stub(@shop_category).name { 'bob' }
        stub(@tag).attr { { 'name' => @shop_category.name } }
        
        mock(ShopCategory).find(:first, {:conditions=>{:name=>@shop_category.name}}) { @shop_category }
        
        result = Shop::Tags::Helpers.current_category(@tag)
        result.should == @shop_category
      end
    end
    context 'position' do
      it 'should return the matching category' do
        stub(@shop_category).position { '10' }
        stub(@tag).attr { { 'position' => @shop_category.position } }
        
        mock(ShopCategory).find(:first, {:conditions=>{:position=>@shop_category.position}}) { @shop_category }
        
        result = Shop::Tags::Helpers.current_category(@tag)
        result.should == @shop_category
      end
    end
    context 'tag.locals.shop_category' do
      it 'should return the matching category' do
        stub(@tag).locals.stub!.shop_category { @shop_category }
        
        result = Shop::Tags::Helpers.current_category(@tag)
        result.should == @shop_category
      end
    end
    context 'tag.locals.page.shop_category_id' do
      it 'should return the matching category' do
        stub(@shop_category).id { 1 }
        stub(@tag).locals.stub!.page.stub!.shop_category_id { @shop_category.id }
        mock(ShopCategory).find(@shop_category.id) { @shop_category }
        
        result = Shop::Tags::Helpers.current_category(@tag)
        result.should == @shop_category
      end
    end
    context 'tag.locals.shop_product' do
      it 'should return the matching category' do
        stub(@tag).locals.stub!.shop_product { @shop_product }
        
        result = Shop::Tags::Helpers.current_category(@tag)
        result.should == @shop_category
      end
    end
    context 'Using page slug' do
      it 'should return the matching category' do
        stub(@shop_category).handle { 'bob' }
        stub(@tag).locals.stub!.page.stub!.slug { @shop_category.handle }
        
        mock(ShopCategory).find(:first, {:conditions=>{:handle=>@shop_category.handle}}) { @shop_category }
        
        result = Shop::Tags::Helpers.current_category(@tag)
        result.should == @shop_category
      end
    end
  end
  
  describe '#current_products(tag)' do
    context 'search query' do
      it 'should return matching products' do
        stub(@tag).locals.stub!.page.stub!.params { {'query'=>'term'} }
        
        mock(ShopProduct).search('term') { @shop_products }
        
        result = Shop::Tags::Helpers.current_products(@tag)
        result.should == @shop_products
      end
    end
    context 'no query' do
      context 'current category' do
        it 'should return all products in that category' do
          @locals = Object.new
          stub(@locals).shop_category     { @shop_category }
          stub(@locals).page.stub!.params { { } }
          stub(@tag).locals               { @locals }
          
          result = Shop::Tags::Helpers.current_products(@tag)
          result.should == @shop_category.products
        end
      end
      
      context 'all results' do
        it 'should return all products' do
          stub(@tag).locals.stub!.page.stub!.params { {} }
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
        stub(@tag).attr { { 'id' => @shop_product.id } }
        
        mock(ShopProduct).find(@shop_product.id) { @shop_product }
        
        result = Shop::Tags::Helpers.current_product(@tag)
        result.should == @shop_product
      end
    end
    context 'sku' do
      it 'should return the matching product' do
        stub(@shop_product).sku { 'bob' }
        stub(@tag).attr { { 'sku' => @shop_product.sku } }
        
        mock(ShopProduct).find(:first, :conditions => { :sku => @shop_product.sku}) { @shop_product }
        
        result = Shop::Tags::Helpers.current_product(@tag)
        result.should == @shop_product
      end
    end
    context 'name' do
      it 'should return the matching product' do
        stub(@shop_product).name { 'bob' }
        stub(@tag).attr { { 'name' => @shop_product.name } }
        
        mock(ShopProduct).find(:first, :conditions => { :name => @shop_product.name}) { @shop_product }
        
        result = Shop::Tags::Helpers.current_product(@tag)
        result.should == @shop_product
      end
    end
    context 'position' do
      it 'should return the matching product' do
        stub(@shop_product).position { '10' }
        stub(@tag).attr { { 'position' => @shop_product.position } }
        
        mock(ShopProduct).find(:first, :conditions => { :position => @shop_product.position}) { @shop_product }
        
        result = Shop::Tags::Helpers.current_product(@tag)
        result.should == @shop_product
      end
    end
    context 'tag.locals.shop_product' do
      it 'should return the matching product' do
        stub(@tag).locals.stub!.shop_product { @shop_product }
        
        result = Shop::Tags::Helpers.current_product(@tag)
        result.should == @shop_product
      end
    end
    context 'tag.locals.page.shop_product_id' do
      it 'should return the matching product' do
        stub(@shop_product).id { 1 }
        stub(@tag).locals.stub!.page.stub!.shop_product_id { @shop_product.id }
        mock(ShopProduct).find(@shop_product.id) { @shop_product }
        
        result = Shop::Tags::Helpers.current_product(@tag)
        result.should == @shop_product
      end
    end
    context 'Using page slug' do
      it 'should return the matching category' do
        stub(@shop_product).sku { 'bob' }
        stub(@tag).locals.stub!.page.stub!.slug { @shop_product.sku }
        
        mock(ShopProduct).find(:first, {:conditions=>{:sku=>@shop_product.sku}}) { @shop_product }
        
        result = Shop::Tags::Helpers.current_product(@tag)
        result.should == @shop_product
      end
    end
  end
  
end