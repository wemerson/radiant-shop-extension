require 'spec/spec_helper'

describe ShopProductVariant do
  
  dataset :shop_products, :shop_product_variants

  describe 'relationships' do
    before :each do
      @product = shop_products(:crusty_bread)
    end
    
    context 'product' do
      it 'should belong to one' do
        @product_variant = shop_product_variants(:mouldy_crusty_bread)
        @product_variant.product.should === @product
      end
    end
  end
  
  describe 'validations' do
    before :each do
      @product_variant = shop_product_variants(:mouldy_crusty_bread)
    end
    context 'product' do
      it 'should require' do
        @product_variant.product = nil
        @product_variant.valid?.should === false
      end
    end
    context 'name' do
      it 'should require' do
        @product_variant.name = nil
        @product_variant.valid?.should === false
      end
    end
    context 'price' do
      it 'should require' do
        @product_variant.price = nil
        @product_variant.valid?.should === false
      end
    end
  end
  
end