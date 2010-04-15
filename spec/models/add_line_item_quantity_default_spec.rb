require File.dirname(__FILE__) + '/../spec_helper'

describe AddLineItemQuantityDefault do
  before(:each) do
    @add_line_item_quantity_default = AddLineItemQuantityDefault.new
  end

  it "should be valid" do
    @add_line_item_quantity_default.should be_valid
  end
end
