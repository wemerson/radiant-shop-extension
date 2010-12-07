require File.dirname(__FILE__) + "/../spec_helper"

describe ShopShipping do
  
  dataset :shop_addresses
  
  describe 'scope' do
    before :each do
      @address = ShopShipping.new
    end
    
    it 'should have a of_type of shipping' do
      @address.of_type.should == 'shipping'
    end
    
  end
  
end