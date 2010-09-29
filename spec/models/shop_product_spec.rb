require 'spec/spec_helper'

describe ShopProduct do
  
  dataset :shop_products
  
  before(:each) do
    @product = shop_products(:soft_bread)
    @products = [
      shop_products(:soft_bread),
      shop_products(:crusty_bread),
      shop_products(:warm_bread)
    ]
  end
  
  describe 'attributes' do
    
    it 'should have a name' do
      @product.name.should == 'soft bread'
    end
    
    it 'should have an sku' do
      @product.sku.should == 'soft_bread'
    end
    
    it 'should have a position' do
      @product.position.should == 1
    end
    
    it 'should have a price' do
      @product.price.should === 10.00
    end
    
    it 'should have a category' do
      @product.category.class.should == ShopCategory
    end
    
  end
  
  describe 'validation' do
    
    it 'should require a name and category' do
      @product = ShopProduct.new
      @product.valid? == false
      
      @product.name = "name"
      @product.valid? == false
      @product.name = nil
      
      @product.category = shop_categories(:bread)
      @product.valid? == false

      @product.name = "name"
      @product.valid? == true
    end
    
    it 'should validate but not require the price' do
      @product = ShopProduct.new({ :name => 'bread', :category => shop_categories(:bread) })
      @product.valid? == true
      
      @product.price = "asdas"
      @product.valid? == false
      
      @product.price = "-999.99"
      @product.valid? == false
      
      @product.price = "9.99.99"
      @product.valid? == false
      
      @product.price = "0.00"
      @product.valid? == false
      
      @product.price = "0.01"
      @product.valid? == true
      
      @product.price = "999999.99"
      @product.valid? == true
    end
    
    it 'should generate a valid sku on validation' do
      @product = ShopProduct.new({ :name => 'dark_ _:_;_=_+_._~_toasted', :category => shop_categories(:bread) })
      @product.valid?     === true
      @product.sku.should === 'dark_______________toasted'
    end
    
    it 'should have an array of images' do
      @product.attachments.class.should == Array
      @product.images.class.should      == Array
      @product.images.length.should     === @product.attachments.length
    end
    
  end
  
  describe '#slug' do
    it 'should return a generated slug' do
      product     = ShopProduct.new
      product.sku = 'product'
      stub(product).category.stub!.handle { 'category' }
      
      product.slug.should === %{/#{Radiant::Config['shop.url_prefix']}/category/product}
    end
  end
  
  describe '#layout' do
    it 'should return the layout defined by its category' do
      @product.layout.should === @product.category.product_layout
    end
  end
  
  describe '#available_images' do
    it 'should return all the Images minus its own' do
      @images = Image.all - @product.images
      
      @product.available_images.should === @images
    end
  end
  
  describe '#slug_prefix' do
    it 'should return the configured shop.url_prefix' do
      @product.slug_prefix.should === Radiant::Config['shop.url_prefix']
    end
  end
  
  context 'Class Methods' do
    
    describe '#attrs' do
      it 'should have a set of standard parameters' do
        ShopProduct.attrs.should === [ :id, :name, :price, :sku, :description, :created_at, :updated_at ]
      end
    end
    
  end
  
end
