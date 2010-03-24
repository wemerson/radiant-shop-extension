require File.dirname(__FILE__) + '/../spec_helper'

describe ShopOrderStatus do
  before(:each) do
    @shop_order_status = ShopOrderStatus.new
  end

  it "should be valid" do
    @shop_order_status.should be_valid
  end
end
