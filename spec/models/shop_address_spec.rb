require File.dirname(__FILE__) + "/../spec_helper"

describe ShopAddress do
  
  dataset :shop_addresses, :shop_orders
  
  describe 'validations' do
    before :each do
      @address = shop_billings(:order_billing)
    end
    context 'unit' do
      it 'should not require' do
        @address.unit = nil
        @address.valid?.should === true
      end
    end
    context 'name' do
      it 'should require' do
        @address.name = nil
        @address.valid?.should === false
      end
    end
    context 'street' do
      it 'should require' do
        @address.street = nil
        @address.valid?.should === false        
      end
    end
    context 'city' do
      it 'should require' do
        @address.city = nil
        @address.valid?.should === false        
      end
    end
    context 'postcode' do
      it 'should require' do
        @address.postcode = nil
        @address.valid?.should === false        
      end
    end
    context 'state' do
      it 'should require' do
        @address.state = nil
        @address.valid?.should === false        
      end
    end
    context 'country' do
      it 'should require' do
        @address.country = nil
        @address.valid?.should === false        
      end
    end
  end
  
end