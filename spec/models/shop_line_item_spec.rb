require File.dirname(__FILE__) + '/../spec_helper'

describe ShopLineItem do
  before(:each) do
    @shop_line_item = ShopLineItem.new
  end

  it "should be valid" do
    @shop_line_item.should be_valid
  end
end
