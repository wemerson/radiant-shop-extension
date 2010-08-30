require 'spec/spec_helper'

describe ShopProductImage do
  dataset :shop_products
  
  before(:each) do
    @product_image = shop_products(:soft_bread).product_images.first
  end
  
  context 'attributes' do
    
    it 'should have a product id' do
      @product_image.product_id.should == shop_products(:soft_bread).id
    end
    
    it 'should have an image id' do
      @product_image.image_id.should == images(:soft_bread_front).id
    end
    
    it 'should have a position' do
      @product_image.position.should == 1
    end
    
    it 'should have a product' do
      @product_image.product.class.should == ShopProduct
    end
    
    it 'should have an image' do
      @product_image.image.class.should == Image
    end
    
  end
  
end
