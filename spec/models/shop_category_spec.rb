require 'spec/spec_helper'

describe ShopCategory do
  dataset :shop_categories
  
  describe 'relationships' do
    
  end
  
  describe 'validations' do
    before :each do
      @category = shop_categories(:bread)
    end
    
    context 'name' do
      it 'should require' do
        @category.name = nil
        @category.valid?.should === false
      end
      
      it 'should be unique' do
        @other = shop_categories(:milk)
        @other.name = @category.name
        @other.valid?.should === false
      end
    end
    
    context 'handle' do      
      it 'should be unique' do
        @other = shop_categories(:milk)
        @other.handle = @category.handle
        @other.valid?.should === false
      end
    end    
  end
  
  describe 'filters' do
    
    context 'handle' do
      it 'should generate on validation' do
        @category = ShopCategory.new({ :name => 'delicious_ _:_;_=_+_._~_bread' })
        @category.valid?
        @category.handle.should === 'delicious_______________bread'
      end
    end
    
    context 'layout' do
      it 'should select on validation' do
        @category = shop_categories(:bread)
        @category.layout_id = nil
        @category.valid?
        @category.layout.should === Layout.find_by_name(Radiant::Config['shop.category_layout'])
      end
    end
    
    context 'product layout' do
      it 'should select on validation' do
        @category = shop_categories(:bread)
        @category.product_layout_id = nil
        @category.valid?
        @category.product_layout.should === Layout.find_by_name(Radiant::Config['shop.product_layout'])
      end
    end
  end
  
  describe '#attrs' do
    it 'should have a set of standard parameters' do
      ShopCategory.attrs.should === [ :id, :handle, :description, :created_at, :updated_at ]
    end
  end
  
end
