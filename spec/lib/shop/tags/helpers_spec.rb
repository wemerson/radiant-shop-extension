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
    stub(@shop_product).category { @shop_category }
    @shop_products  = [ product, product, product ]
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
    
  end
  
  describe '#current_product(tag)' do
    
  end
  
end