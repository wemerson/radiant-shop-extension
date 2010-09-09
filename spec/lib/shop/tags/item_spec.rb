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
      'shop:cart:item:name',
      'shop:cart:item:link',
      'shop:cart:item:price',
      'shop:cart:item:weight',
      'shop:cart:item:remove'].sort
  end
  
  before :all do
    @page = pages(:home)
  end
  
  before :each do
    order = Object.new
    stub(order).id { 1 }
    @shop_order = order
    
    item = Object.new
    stub(item).id { 1 }
    @shop_line_item = item
    
    product = Object.new
    stub(product).id { 1 }
    @shop_product = product
    
    stub(@shop_line_item).item  { @shop_product }
    stub(@shop_line_item).order { @shop_order }
    
    @shop_line_items = [ @shop_line_item, @shop_line_item, @shop_line_item ]
    stub(@shop_order).line_items  { @shop_line_items }
  end
  
  context 'within a cart' do
    
    before :each do
      mock(Shop::Tags::Helpers).current_order(anything) { @shop_order }
    end
    
    context 'group of items' do
      describe '<r:shop:cart:if_items>' do
        context 'success' do
          it 'should render' do
            tag = %{<r:shop:cart:if_items>success</r:shop:cart:if_items>}
            expected = %{success}
            @page.should render(tag).as(expected)
          end
        end
        context 'failure' do
          it 'should render' do
            stub(@shop_order).line_items { [] }
          
            tag = %{<r:shop:cart:if_items>failure</r:shop:cart:if_items>}
            expected = %{}
            @page.should render(tag).as(expected)
          end
        end
      end
      
      describe '<r:shop:cart:unless_items>' do
        context 'success' do
          it 'should render' do
            stub(@shop_order).line_items { [] }
          
            tag = %{<r:shop:cart:unless_items>success</r:shop:cart:unless_items>}
            expected = %{success}
            @page.should render(tag).as(expected)
          end
        end
        context 'failure' do
          it 'should render' do
            tag = %{<r:shop:cart:unless_items>failure</r:shop:cart:unless_items>}
            expected = %{}
            @page.should render(tag).as(expected)
          end
        end
      end
      
      describe '<r:shop:cart:items>' do
        context 'items exist' do
          it 'should render' do
            tag = %{<r:shop:cart:items>success</r:shop:cart:items>}
            expected = %{success}
            
            @page.should render(tag).as(expected)
          end
        end
        
        context 'items dont exist' do
          it 'should render' do
            tag = %{<r:shop:cart:items>success</r:shop:cart:items>}
            expected = %{success}
            
            @page.should render(tag).as(expected)
          end
        end
      end
      
      describe '<r:shop:cart:items:each' do
        context 'success' do
          it 'should render' do
            tag = %{<r:shop:cart:items:each>.a.</r:shop:cart:items:each>}
            expected = %{.a..a..a.}
            
            @page.should render(tag).as(expected)
          end
          it 'should assign the local item' do
            tag = %{<r:shop:cart:items:each><r:item:id /></r:shop:cart:items:each>}
            expected = %{111}
            
            @page.should render(tag).as(expected)
          end  
          it 'should assign the local product' do
            tag = %{<r:shop:cart:items:each><r:product:id /></r:shop:cart:items:each>}
            expected = %{111}
            
            @page.should render(tag).as(expected)
          end
        end
        context 'failure' do
          it 'should not render' do
            stub(@shop_order).line_items { [] }
            
            tag = %{<r:shop:cart:items:each></r:shop:cart:items:each>}
            expected = %{}
            
            @page.should render(tag).as(expected)
          end
        end
      end
    end
      
    context 'a single item' do
      describe '<r:shop:cart:item>' do
        context 'success' do
          it 'should render' do
            mock(Shop::Tags::Helpers).current_line_item(anything) { @shop_line_item }
            
            tag = %{<r:shop:cart:item>success</r:shop:cart:item>}
            expected = %{success}
            
            @page.should render(tag).as(expected)
          end
        end
        
        context 'failure' do
          it 'should not render' do
            mock(Shop::Tags::Helpers).current_line_item(anything) { nil }
            tag = %{<r:shop:cart:item>failure</r:shop:cart:item>}
            expected = %{}
            
            @page.should render(tag).as(expected)
          end
        end
        
        describe 'simple attributes' do
          before :each do
            mock(Shop::Tags::Helpers).current_line_item(anything) { @shop_line_item }
          end
          it 'should render <r:id />' do
            stub(@shop_line_item).id { 1 }
            
            tag = %{<r:shop:cart:item:id />}
            expected = %{1}
            
            @page.should render(tag).as(expected)
          end
          it 'should render <r:quantity />' do
            stub(@shop_line_item).quantity { 1 }
            
            tag = %{<r:shop:cart:item:quantity />}
            expected = %{1}
            
            @page.should render(tag).as(expected)
          end
        end
        
        describe 'item attributes' do
          before :each do
            mock(Shop::Tags::Helpers).current_line_item(anything) { @shop_line_item }
          end
          it 'should render <r:name />' do
            stub(@shop_line_item).item.stub!.name { 'name' }
            
            tag = %{<r:shop:cart:item:name />}
            expected = %{name}
            
            @page.should render(tag).as(expected)
          end
          it 'should render <r:weight />' do
            stub(@shop_line_item).item.stub!.weight { 100 }
            
            tag = %{<r:shop:cart:item:weight />}
            expected = %{100}
            
            @page.should render(tag).as(expected)
          end
        end
        
        describe '<r:shop:cart:item:link />' do
          before :each do
            mock(Shop::Tags::Helpers).current_line_item(anything) { @shop_line_item }
          end

          context 'standalone' do
            before :each do
              item = Object.new
              stub(@shop_line_item).item { item }
              stub(item).slug { 'slug' }
              stub(item).name { 'name' }
            end
            it 'should render an anchor element' do
              tag = %{<r:shop:cart:item:link />}
              expected = %{<a href="slug">name</a>}
              pages(:home).should render(tag).as(expected)
            end
            it 'should assign attributes' do
              tag = %{<r:shop:cart:item:link title="title" data-title="data-title"/>}
              expected = %{<a href="slug" data-title="data-title" title="title">name</a>}
              pages(:home).should render(tag).as(expected)          
            end
          end

          context 'wrapped' do
            it 'should render an anchor element' do
              item = Object.new
              stub(@shop_line_item).item { item }
              stub(item).slug { 'slug' }

              tag = %{<r:shop:cart:item:link>title</r:shop:cart:item:link>}
              expected = %{<a href="slug">title</a>}
              pages(:home).should render(tag).as(expected)
            end
          end
        end
        
        describe '<r:shop:cart:item:price />' do
          before :each do
            mock(Shop::Tags::Helpers).current_line_item(anything) { @shop_line_item }
            
            stub(@shop_line_item).price { 1234.34567890 }
          end
          
          it 'should render a standard price' do
            tag = %{<r:shop:cart:item:price />}
            expected = %{$1,234.35}
            
            @page.should render(tag).as(expected)
          end
          
          it 'should render a high precision price' do
            tag = %{<r:shop:cart:item:price precision="8"/>}
            expected = %{$1,234.34567890}
            
            @page.should render(tag).as(expected)
          end
          
          it 'should render a custom format' do
            tag = %{<r:shop:cart:item:price unit="%" separator="-" delimiter="+" />}
            expected = %{%1+234-35}
            
            @page.should render(tag).as(expected)
          end
        end
        
        describe '<r:shop:cart:item:remove />' do
          before :each do
            mock(Shop::Tags::Helpers).current_line_item(anything) { @shop_line_item }
          end
          
          context 'standalone' do
            it 'should render an anchor element' do
              tag = %{<r:shop:cart:item:remove />}
              expected = %{<a href="/#{Radiant::Config['shop.url_prefix']}/cart/items/#{@shop_line_item.id}/destroy">remove</a>}
              pages(:home).should render(tag).as(expected)
            end
            it 'should assign attributes' do
              tag = %{<r:shop:cart:item:remove title="title" data-title="data-title"/>}
              expected = %{<a href="/#{Radiant::Config['shop.url_prefix']}/cart/items/#{@shop_line_item.id}/destroy" data-title="data-title" title="title">remove</a>}
              pages(:home).should render(tag).as(expected)
            end
          end

          context 'wrapped' do
            it 'should render an anchor element' do
              tag = %{<r:shop:cart:item:remove>get rid of me</r:shop:cart:item:remove>}
              expected = %{<a href="/#{Radiant::Config['shop.url_prefix']}/cart/items/#{@shop_line_item.id}/destroy">get rid of me</a>}
              pages(:home).should render(tag).as(expected)
            end
          end
        end
        
      end
    end
  end
end
