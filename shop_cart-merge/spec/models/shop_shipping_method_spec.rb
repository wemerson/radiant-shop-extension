require 'spec/spec_helper'

describe ShopShippingMethod do
  before(:each) do
    @shop_shipping_method = ShopShippingMethod.new
  end

  it "should be valid" do
    @shop_shipping_method.should be_valid
  end
end
