require 'spec/spec_helper'

describe ShopProductAttachment do
  dataset :shop_products
  
  context 'attributes' do
  
    before(:each) do
      @product_image = shop_products(:soft_bread).attachments.first
    end
      
    it 'should have a product id' do
      @product_image.product.should === shop_products(:soft_bread)
    end
    
    it 'should have an image id' do
      @product_image.image.should === images(:soft_bread_front)
    end
    
    it 'should have a position' do
      @product_image.position.should === 1
    end
    
    it 'should have a product' do
      @product_image.product.class.should == ShopProduct
    end
    
    it 'should have an image' do
      @product_image.image.class.should == Image
    end
    
  end
  
  context 'alias methods' do
    
    before(:each) do
      stub(AWS::S3::Base).establish_connection!
      @product_image = shop_products(:soft_bread).attachments.first
    end
    
    describe '#url' do
      it 'should return its assets url' do
        @product_image.url.should === @product_image.image.url
      end
    end
    describe '#title' do
      it 'should return its assets title' do
        @product_image.title.should === @product_image.image.title
      end
    end
    describe '#caption' do
      it 'should return its assets caption' do
        @product_image.caption.should === @product_image.image.caption
      end
    end
  end
  
  context 'class methods' do
    describe '#params' do
      it 'should have a set of standard parameters' do
        ShopProductAttachment.params.should === [
          :id,
          :title,
          :caption,
          :image_file_name,
          :image_content_type,
          :image_file_size
        ]
      end
    end
  end
  
end
