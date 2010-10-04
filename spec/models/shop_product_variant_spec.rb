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
      it 'should not require' do
        @product_variant.price = nil
        @product_variant.valid?.should === true
      end
    end
  end
  
  describe '#price' do
    before :each do
      @product_variant = shop_product_variants(:mouldy_crusty_bread)
    end
    context 'positive price' do
      before :each do
        @product_variant.price = 100.00
      end
      it 'should return the product price plus the variant price' do
        @product_variant.price.to_f.should === (@product_variant.product.price.to_f + 100.00)
      end
    end
    context 'negative price' do
      before :each do
        @product_variant.price = -100.00
      end
      it 'should return the product price plus the variant price' do
        @product_variant.price.to_f.should === (@product_variant.product.price.to_f - 100.00)
      end
    end
  end
  
  describe '#sku' do
    before :each do
      @product_variant = shop_product_variants(:mouldy_crusty_bread)
      stub(@product_variant).name { 'mouldy and yucky'}
    end
    it 'should return a concatenation of its name and products sku' do
      @product_variant.sku.should === "#{@product_variant.product.sku}-mouldy_and_yucky"
    end
  end
  
  describe '#sku' do
    before :each do
      @product_variant = shop_product_variants(:mouldy_crusty_bread)
    end
    it 'should return its products slug' do
      @product_variant.slug.should === @product_variant.product.slug
    end
  end
  
end