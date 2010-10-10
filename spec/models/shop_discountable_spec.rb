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
  
end