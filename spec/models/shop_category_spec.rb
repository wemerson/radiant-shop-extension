require File.dirname(__FILE__) + '/../spec_helper'

describe ShopCategory do
  dataset :shop_categories
  
  before(:each) do
    @category = shop_categories(:bread)
    @categories = [
      shop_categories(:bread),
      shop_categories(:milk)
    ]
  end
  
  context 'attributes' do
    
    it 'should have a title' do
      @category.name.should == 'bread'
    end
    
    it 'should have a handle' do
      @category.handle.should == 'bread'
    end
    
    it 'should have a position' do
      @category.position.should == 1
    end
    
    it 'should have a products array' do
      @category.products.class.should == Array
    end
    
  end
  
  context 'validation' do
    
    it 'should generate a valid handle on validation' do
      @product = ShopCategory.new({ :name => 'delicious_ _:_;_=_+_._~_bread' })
      @product.valid? == true
      @product.handle.should == 'delicious_-_-_-_-_-_-_-_bread'
    end
    
  end
  
end