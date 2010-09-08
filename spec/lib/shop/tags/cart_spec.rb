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
      'shop:cart:link',
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
    order = Object.new
    
    @shop_order = order
    @shop_orders = [ order, order, order ]
    
    item = Object.new
  end
  
  context 'outside cart context' do
    describe '<r:shop:if_cart>' do
      context 'success' do
        it 'should render' do
          mock(Shop::Tags::Helpers).current_order(anything) { @shop_order }
          
          tag = %{<r:shop:if_cart>success</r:shop:if_cart>}
          expected = %{success}
          @page.should render(tag).as(expected)
        end
      end
      context 'failure' do
        it 'should render' do
          mock(Shop::Tags::Helpers).current_order(anything) { nil }
          
          tag = %{<r:shop:if_cart>failure</r:shop:if_cart>}
          expected = %{}
          @page.should render(tag).as(expected)
        end
      end
    end
    
    describe '<r:shop:unless_cart>' do
      context 'success' do
        it 'should render' do
          mock(Shop::Tags::Helpers).current_order(anything) { nil }
          
          tag = %{<r:shop:unless_cart>success</r:shop:unless_cart>}
          expected = %{success}
          @page.should render(tag).as(expected)
        end
      end
      context 'failure' do
        it 'should render' do
          mock(Shop::Tags::Helpers).current_order(anything) { @shop_order }
          
          tag = %{<r:shop:unless_cart>failure</r:shop:unless_cart>}
          expected = %{}
          @page.should render(tag).as(expected)
        end
      end
    end
    
    describe '<r:shop:cart>' do
      context 'success' do
        it 'should render' do
          mock(Shop::Tags::Helpers).current_order(anything) { @shop_order }
          
          tag = %{<r:shop:cart>success</r:shop:cart>}
          expected = %{success}
          
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
    
    describe 'simple attributes' do
      before :each do
        mock(Shop::Tags::Helpers).current_order(anything) { @shop_order }
      end
      it 'should render <r:id />' do
        stub(@shop_order).id { 1 }
        
        tag = %{<r:shop:cart:id />}
        expected = %{1}
        
        @page.should render(tag).as(expected)
      end
      it 'should render <r:status />' do
        stub(@shop_order).status { 'new' }
        
        tag = %{<r:shop:cart:status />}
        expected = %{new}
        
        @page.should render(tag).as(expected)
      end
      it 'should render <r:quantity />' do
        stub(@shop_order).quantity { 1 }
        
        tag = %{<r:shop:cart:quantity />}
        expected = %{1}
        
        @page.should render(tag).as(expected)
      end
      it 'should render <r:weight />' do
        stub(@shop_order).weight { 100 }
        
        tag = %{<r:shop:cart:weight />}
        expected = %{100}
        
        @page.should render(tag).as(expected)
      end
    end
    
    describe '<r:link />' do
      before :each do
        mock(Shop::Tags::Helpers).current_order(anything) { @shop_order }
      end
      context 'standalone' do
        it 'should render an anchor element' do
          tag = %{<r:shop:cart:link />}
          expected = %{<a href="/#{Radiant::Config['shop.url_prefix']}/cart">Your Cart</a>}
          pages(:home).should render(tag).as(expected)
        end
        it 'should assign attributes' do
          tag = %{<r:shop:cart:link title="title" data-title="data-title"/>}
          expected = %{<a href="/#{Radiant::Config['shop.url_prefix']}/cart" data-title="data-title" title="title">Your Cart</a>}
          pages(:home).should render(tag).as(expected)
        end
      end

      context 'wrapped' do
        it 'should render an anchor element' do
          tag = %{<r:shop:cart:link>checkout</r:shop:cart:link>}
          expected = %{<a href="/#{Radiant::Config['shop.url_prefix']}/cart">checkout</a>}
          pages(:home).should render(tag).as(expected)
        end
      end
    end
    
    describe '<r:price />' do
      before :each do
        mock(Shop::Tags::Helpers).current_order(anything) { @shop_order }
        stub(@shop_order).price { 1234.34567890 }
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