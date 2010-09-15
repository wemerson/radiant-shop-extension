require 'spec/spec_helper'

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
      @product.handle.should == 'delicious_______________bread'
    end
    
  end

  it 'should find a category by handle' do
    ShopCategory.find_by_handle(@category.handle).should == @category
  end
  
  context 'Class Methods' do
    
    describe '#attrs' do
      it 'should have a set of standard parameters' do
        ShopCategory.attrs.should === [ :id, :handle, :description, :created_at, :updated_at ]
      end
    end
    
  end
  
end
