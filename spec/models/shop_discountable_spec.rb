require 'spec/spec_helper'

describe ShopDiscountable do
  
  dataset :shop_discountables
  
  before(:each) do
    @discount  = shop_discounts(:ten_percent)
  end
  
  describe 'validations' do
    before :each do
      @discountable = shop_discountables(:ten_percent_bread)
    end
    
    context 'discount' do
      it 'should require' do
        @discountable.discount = nil
        @discountable.valid?.should === false
      end
    end
    
    context 'discounted' do
      it 'should require' do
        @discountable.discounted = nil
        @discountable.valid?.should === false
      end
      it 'should be unique to the class' do
        @other = ShopDiscountable.new(:discount => @discount, :discounted => @discountable.discounted)
        @other.valid?.should === false
        
        @other.discounted = shop_categories(:milk)
        @other.valid?.should === true
      end
    end
  end
  
  describe 'category and product hooks' do
    describe '#add_category' do
      before :each do
        @discount = shop_discounts(:one_percent)
        @category = shop_categories(:milk)
        
        discountable = @discount.discountables.create(:discounted => @category)      
      end
      it 'should assign the category to the discount' do
        @discount.categories.include?(@category).should === true
      end
      it 'should assign the products to that category' do
        @discount.products.should_not be_empty
        @discount.products.should === @category.products
      end
    end
  
    describe '#remove_category' do
      before :each do
        @discount = shop_discounts(:one_percent)
        @category = shop_categories(:milk)
        
        discountable = @discount.discountables.create(:discounted => @category)
        discountable.destroy
      end
      it 'should remove the category to the discount' do
        @discount.categories.include?(@category).should === false
      end
      it 'should remove the products of that category' do
        @category.products.each do |p|
          @discount.products.include?(p).should === false
        end
      end
    end
  end
  
end