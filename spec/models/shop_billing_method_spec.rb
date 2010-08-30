require 'spec/spec_helper'

describe ShopBillingMethod do
  before(:each) do
    @shop_billing_method = ShopBillingMethod.new
  end

  it "should be valid" do
    @shop_billing_method.should be_valid
  end
end
