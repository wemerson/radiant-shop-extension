require 'spec/spec_helper'

#
# Tests for shop order page model extensions
#
describe Shop::Models::Image do
  
  dataset :images, :shop_products
  
  before :each do
    @image = images(:soft_bread_front)
  end
  
  context 'relationships' do
    
    describe 'belongs_to :shop_category' do
      it 'should accept and return a shop_category object' do
        @shop_product = shop_products(:soft_bread)
        
        @image.shop_products << @shop_product
        
        @image.shop_products.include?(@shop_product).should === true
      end
    end
    
  end
  
end