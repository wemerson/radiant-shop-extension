require File.dirname(__FILE__) + '/../spec_helper'

describe ShopPayment do
  before(:each) do
    @shop_payment = ShopPayment.new
  end

  it "should be valid" do
    @shop_payment.should be_valid
  end
end
