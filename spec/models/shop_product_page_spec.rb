require File.dirname(__FILE__) + "/../spec_helper"

describe ShopProductPage do

  it 'should not have a cache' do
    s = ShopProductPage.new
    s.cache?.should === false
  end

end