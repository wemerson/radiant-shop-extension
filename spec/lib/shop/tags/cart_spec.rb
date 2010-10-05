require 'spec/spec_helper'
require 'spec/helpers/nested_tag_helper'

#
# Tests for shop order tags module
#
describe Shop::Tags::Cart do
  
  dataset :pages, :shop_orders
  
  it 'should describe these tags' do
    Shop::Tags::Cart.tags.sort.should == [
      'shop:cart:if_cart',
      'shop:cart:unless_cart',
      'shop:cart',
      'shop:cart:id',
      'shop:cart:status',
      'shop:cart:quantity',
      'shop:cart:weight',
      'shop:cart:price'].sort
  end
  
  before :all do
    @page = pages(:home)
  end
  
  before :each do
    @order = shop_orders(:several_items)
  end
  
  context 'cart tags' do    
    describe '<r:shop:cart>' do
      context 'success' do
        it 'should render' do
          mock(Shop::Tags::Helpers).current_order(anything) { @order }
          
          tag = %{<r:shop:cart>success</r:shop:cart>}
          expected = %{success}
          
          @page.should render(tag).as(expected)
        end
      end
      
      context 'failure' do
        it 'should render' do
          tag = %{<r:shop:cart>success</r:shop:cart>}
          expected = %{success}
        
          @page.should render(tag).as(expected)
        end
      end
    end
    
    describe '<r:shop:cart:if_cart>' do
      context 'success' do
        it 'should render' do
          mock(Shop::Tags::Helpers).current_order(anything) { @order }
          
          tag = %{<r:shop:cart:if_cart>success</r:shop:cart:if_cart>}
          expected = %{success}
          @page.should render(tag).as(expected)
        end
      end
      context 'failure' do
        it 'should render' do
          mock(Shop::Tags::Helpers).current_order(anything) { nil }
          
          tag = %{<r:shop:cart:if_cart>failure</r:shop:cart:if_cart>}
          expected = %{}
          @page.should render(tag).as(expected)
        end
      end
    end
    
    describe '<r:shop:cart:unless_cart>' do
      context 'success' do
        it 'should render' do
          mock(Shop::Tags::Helpers).current_order(anything) { nil }
          
          tag = %{<r:shop:cart:unless_cart>success</r:shop:cart:unless_cart>}
          expected = %{success}
          @page.should render(tag).as(expected)
        end
      end
      context 'failure' do
        it 'should render' do
          mock(Shop::Tags::Helpers).current_order(anything) { @order }
          
          tag = %{<r:shop:cart:unless_cart>failure</r:shop:cart:unless_cart>}
          expected = %{}
          @page.should render(tag).as(expected)
        end
      end
    end
    
    describe 'simple attributes' do
      before :each do
        mock(Shop::Tags::Helpers).current_order(anything) { @order }
      end
      it 'should render <r:id />' do
        tag = %{<r:shop:cart:id />}
        expected = @order.id.to_s
        
        @page.should render(tag).as(expected)
      end
      it 'should render <r:status />' do
        tag = %{<r:shop:cart:status />}
        expected = @order.status
        
        @page.should render(tag).as(expected)
      end
      it 'should render <r:quantity />' do
        stub(@shop_order).quantity { 1 }
        
        tag = %{<r:shop:cart:quantity />}
        expected = @order.quantity.to_s
        
        @page.should render(tag).as(expected)
      end
      it 'should render <r:weight />' do
        tag = %{<r:shop:cart:weight />}
        expected = @order.weight.to_s
        
        @page.should render(tag).as(expected)
      end
    end
    
    describe '<r:price />' do
      before :each do
        mock(Shop::Tags::Helpers).current_order(anything) { @order }
        stub(@order).price { 1234.34567890 }
      end
      
      it 'should render a standard price' do
        tag = %{<r:shop:cart:price />}
        expected = %{$1,234.35}
        
        @page.should render(tag).as(expected)
      end
      
      it 'should render a high precision price' do
        tag = %{<r:shop:cart:price precision="8"/>}
        expected = %{$1,234.34567890}
        
        @page.should render(tag).as(expected)
      end
      
      it 'should render a custom format' do
        tag = %{<r:shop:cart:price unit="%" separator="-" delimiter="+" />}
        expected = %{%1+234-35}
        
        @page.should render(tag).as(expected)
      end
    end
    
  end
  
end