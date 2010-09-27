require 'spec/spec_helper'

describe ShopCategoryPage do

  it 'should not have a cache' do
    page = ShopCategoryPage.new
    page.cache?.should === false
  end

end