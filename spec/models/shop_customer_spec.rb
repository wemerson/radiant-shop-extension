require File.dirname(__FILE__) + '/../spec_helper'

describe ShopCustomer do
  before(:each) do
    @shop_customer = ShopCustomer.new
  end

  it "should be valid" do
    @shop_customer.should be_valid
  end
end
