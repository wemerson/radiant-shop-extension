require File.dirname(__FILE__) + "/../../../spec_helper"

#
# Tests for image model extensions
#
describe Shop::Models::Image do
  
  dataset :shop_products, :shop_product_attachments
  
  before :each do
    @image = images(:soft_bread_front)
  end
  
  context 'relationships' do
    
    describe 'product' do
      it 'should accept and return a product object' do
        @shop_product = shop_products(:soft_bread)
        
        @image.shop_products << @shop_product
        
        @image.shop_products.include?(@shop_product).should === true
      end
    end
    
  end
  
end