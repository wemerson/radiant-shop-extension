require 'spec/spec_helper'
require 'spec/helpers/nested_tag_helper'

#
# Test for Shop Line Item Tags
#
describe Shop::Tags::Item do
  
  dataset :pages
  
  it 'should describe these tags' do
    Shop::Tags::Item.tags.sort.should == [
      'shop:cart:if_items',
      'shop:cart:unless_items',
      'shop:cart:items',
      'shop:cart:items:each',
      'shop:cart:item',
      'shop:cart:item:id',
      'shop:cart:item:quantity',
      'shop:cart:item:weight',
      'shop:cart:item:price',
      'shop:cart:item:remove'].sort
  end
  
end
