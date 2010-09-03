require 'spec/spec_helper'
require 'spec/helpers/nested_tag_helper'

#
# Tests for shop order tags module
#
describe Shop::Tags::Cart do

  dataset :pages

  it 'should describe these tags' do
    Shop::Tags::Cart.tags.sort.should == [
      'shop:if_cart',
      'shop:unless_cart',
      'shop:cart',
      'shop:cart:id',
      'shop:cart:status',
      'shop:cart:quantity',
      'shop:cart:weight',
      'shop:cart:price'].sort
  end
  
  before :all do
    @tags = NestedTagHelper.new
    @page = pages(:home)
  end
  
  before :each do
    order = Object.new
    
    @shop_order = order
    @shop_orders = [ order, order, order ]
    
    item = Object.new
    
    @shop_line_item = item
    @shop_line_items = [ item, item, item ]
    
    stub(@shop_order).line_items { @shop_line_items }
    stub(@shop_line_item).order { @shop_order }
  end

  context 'outside cart context' do
    describe '<r:shop:if_cart>' do
      context 'success' do
        it 'should render' do
          mock(Shop::Tags::Helpers).current_order(anything) { @shop_order }

          tag = %{<r:shop:if_order>success</r:shop:if_order>}
          expected = %{success}
          @page.should render(tag).as(expected)
        end
      end
    end
    
    describe '<r:shop:unless_cart>' do
      
    end
    
    describe '<r:shop:cart>' do
      context 'success' do
        it 'should render' do
          mock(Shop::Tags::Helpers).current_order(anything) { @shop_order }

          tag = %{<r:shop:cart>Success</r:shop:cart>}
          expected = %{}
        
          @page.should render(tag).as(expected)
        end
      end
      
      context 'failure' do
        it 'should not render' do
          tag = %{<r:shop:cart>Failure</r:shop:cart>}
          expected = %{}
        
          @page.should render(tag).as(expected)
        end
      end
    end
  end
  
end