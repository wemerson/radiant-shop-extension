require 'spec/spec_helper'

describe ShopCategoryPage do

  it 'should not have a cache' do
    s = ShopProductPage.new
    s.cache?.should === false
  end

end