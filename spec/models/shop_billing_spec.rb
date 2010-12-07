require File.dirname(__FILE__) + "/../spec_helper"

describe ShopBilling do
  
  dataset :shop_addresses
  
  describe 'scope' do
    before :each do
      @address = ShopBilling.new
    end
    
    it 'should have a of_type of billing' do
      @address.of_type.should == 'billing'
    end
    
  end
  
end