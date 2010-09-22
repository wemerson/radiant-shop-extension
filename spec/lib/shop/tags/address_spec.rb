require 'spec/spec_helper'

#
# Tests for shop address tags
#
describe Shop::Tags::Address do
  
  dataset :pages, :shop_addresses, :shop_orders
  
  it 'should describe these tags' do
    Shop::Tags::Address.tags.sort.should == [].sort
  end

end