require File.dirname(__FILE__) + '/../spec_helper'

describe ShopOrder do
  before(:each) do
    @shop_order = ShopOrder.new
  end

  it "should be valid" do
    @shop_order.should be_valid
  end
end
