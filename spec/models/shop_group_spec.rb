require 'spec/spec_helper'

describe ShopGroup do

  dataset :shop_groups

  context 'associations' do
    before :each do
      @group = shop_groups(:breakfast)
    end
    
    describe 'products' do
      before :each do
        @product = shop_products(:crusty_bread)
      end
      
      it 'should contain an array of products' do
        @group.products.include?(@product).should === true
      end
      
      it 'should accept new products' do
        @product = shop_products(:choc_milk)
        @group.products << @product
        @group.products.include?(@product).should === true
      end
    end
  end

end