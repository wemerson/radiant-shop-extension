require 'spec/spec_helper'

describe ShopDiscount do
  
  dataset :shop_discounts, :shop_categories

  describe 'validations' do
    before :each do
      @discount = shop_discounts(:ten_percent)
    end
    
    context 'name' do
      it 'should require' do
        @discount.name = nil
        @discount.valid?.should === false
      end
      it 'should be unique' do
        @other = shop_discounts(:five_percent)
        @other.name = @discount.name
        @other.valid?.should === false
      end
    end
    
    context 'code' do
      it 'should require' do
        @discount.code = nil
        @discount.valid?.should === false
      end
      it 'should be unique' do
        @other = shop_discounts(:five_percent)
        @other.code = @discount.code
        @other.valid?.should === false
      end
    end
    
    context 'amount' do
      it 'should require' do
        @discount.amount = nil
        @discount.valid?.should === false
      end
      it 'should be numerical' do
        @discount.amount = 'failure'
        @discount.valid?.should === false
      end
    end
  end
  
  describe 'relationships' do
    before :each do
      @discount = shop_discounts(:five_percent)
    end
    context 'categories' do
      before :each do
        @bread = shop_categories(:bread)
      end
      it 'should have many' do
        @discount.discountables.create(:discounted => @bread)
        @discount.categories.include?(@bread).should === true
      end
    end
  end
  
end