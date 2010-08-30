require 'spec/spec_helper'

describe ShopOrder do

  dataset :shop_orders

  it 'should calculate a total weight' do
    shop_orders(:empty).weight.should == 0
    shop_orders(:one_item).weight.should == 31.0
    shop_orders(:several_items).weight.should == 92.0
  end

  it 'should calculate the total price' do
    shop_orders(:empty).price.should == 0
    shop_orders(:one_item).price.should == 11.0
    shop_orders(:several_items).price.should == 32.0
  end

end
