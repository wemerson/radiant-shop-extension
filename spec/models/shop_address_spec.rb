require File.dirname(__FILE__) + '/../spec_helper'

describe ShopAddress do
  before(:each) do
    @shop_address = ShopAddress.new
  end

  it "should be valid" do
    @shop_address.should be_valid
  end
end
