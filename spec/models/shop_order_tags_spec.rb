require 'spec/spec_helper'
require 'spec/helpers/nested_tag_helper'

#
# Tests for shop order tags module
#
describe ShopOrderTags do
  dataset :pages, :shop_orders

  it 'should have certain tags something' do
    ShopOrderTags.tags.sort.should == [
      'shop:cart',
      'shop:cart:id',
      'shop:cart:item',
      'shop:cart:item:delete',
      'shop:cart:item:id',
      'shop:cart:item:price',
      'shop:cart:item:quantity',
      'shop:cart:item:weight',
      'shop:cart:items',
      'shop:cart:items:each',
      'shop:cart:price',
      'shop:cart:product',
      'shop:cart:quantity',
      'shop:cart:status',
      'shop:cart:weight',
      'shop:product'].sort
  end

  describe 'tag tests' do
    before :each do
      @tags = NestedTagHelper.new
    end

    describe '<r:shop:cart>' do
      it 'should raise an exception if no id is specified' do
        tag = '<r:shop:cart>Hello</r:shop:cart>'

        pages(:home).should_not render(tag)
      end

      it 'should raise an exception if the shop item is not specified' do
        tag = '<r:shop:cart id="1">Hello</r:shop:cart>'

        pages(:home).should_not render(tag)
      end

      it 'should render the shop line item' do
        shop_order = ShopOrder.create

        tag = %{<r:shop:cart id="#{shop_order.id}">Hello</r:shop:cart>}

        expected = %{Hello}

        pages(:home).should render(tag).as(expected)
      end
    end

    context 'inside a shopping cart tag' do
      before :each do
        @shop_order = shop_orders(:one_item)
        @tags.push %{<r:shop:cart id="#{@shop_order.id}">}, '</r:shop:cart>'
      end

      describe '<r:shop:cart:(id|status)>' do
        [:id, :status].each do |symbol|
          it 'should output the symbol' do
            @tags.push "<r:shop:cart:#{symbol}/>"

            pages(:home).should render(@tags.to_s)
          end
        end
      end

      describe '<r:shop:cart:quantity>' do
        it 'should render the quantity' do
          @tags.push '<r:shop:cart:quantity/>'

          pages(:home).should render(@tags.to_s)
        end

        it 'should render the quantity' do
          @tags.push '<r:shop:cart:quantity/>'

          pages(:home).should render(@tags.to_s).as('1')
        end
      end

      describe '<r:shop:cart:price>' do
        it 'should display the value of the shopping cart' do
          @tags.push '<r:shop:cart:price/>'

          pages(:home).should render(@tags.to_s).as('$11.00')
        end
      end

      describe '<r:shop:cart:weight>' do
        it 'should display the weight of the shopping cart' do
          @tags.push '<r:shop:cart:weight/>'

          pages(:home).should render(@tags.to_s).as('0.0')
        end
      end

      describe '<r:shop:cart:items>' do
        it 'should display the shop items' do
          @tags.push '<r:shop:cart:items>Hello</r:shop:cart:items>'

          pages(:home).should render(@tags.to_s).as('Hello')
        end
      end

      describe '<r:shop:cart:items:each>' do

        before :each do
          @product = @shop_order.products.first
          @tags.push '<r:shop:cart:items:each>', '</r:shop:cart:items:each>'
        end

        it 'should display a blank string if no inner tags are supplied' do
          pages(:home).should render(@tags.to_s).as('')
        end

        context 'has products and line items' do

          describe '<r:shop:cart:item:id>' do
            it 'should render an item id' do
              @tags.push '<r:shop:cart:item:id/>'

              pages(:home).should render(@tags.to_s).as %{<form action='/shop/cart/items/#{@product.id}' method='post'><input type='hidden' name='_method' value='put' /><input type='hidden' name='shop_line_item[product_id]' value='#{@product.id}' />#{@product.id}<input type='submit' name='update_item' id='update_item#{@product.id}' value='Update' /></form>}
            end
          end

          describe '<r:shop:cart:item:quantity>' do
            it 'should render an item quantity' do
              @tags.push '<r:shop:cart:item:quantity/>'

              pages(:home).should render(@tags.to_s).as %{<form action='/shop/cart/items/#{@product.id}' method='post'><input type='hidden' name='_method' value='put' /><input type='hidden' name='shop_line_item[product_id]' value='#{@product.id}' />1<input type='submit' name='update_item' id='update_item#{@product.id}' value='Update' /></form>}
            end
          end

          describe '<r:shop:cart:item:price>' do
            it 'should render an item price' do
              @tags.push '<r:shop:cart:item:price/>'

              pages(:home).should render(@tags.to_s).as %{<form action='/shop/cart/items/#{@product.id}' method='post'><input type='hidden' name='_method' value='put' /><input type='hidden' name='shop_line_item[product_id]' value='#{@product.id}' />$11.00<input type='submit' name='update_item' id='update_item#{@product.id}' value='Update' /></form>}
            end
          end

          describe '<r:shop:cart:item:weight>' do
            it 'should render an item weight' do
              @tags.push '<r:shop:cart:item:weight/>'

              pages(:home).should render(@tags.to_s).as %{<form action='/shop/cart/items/#{@product.id}' method='post'><input type='hidden' name='_method' value='put' /><input type='hidden' name='shop_line_item[product_id]' value='#{@product.id}' />0.0<input type='submit' name='update_item' id='update_item#{@product.id}' value='Update' /></form>}
            end
          end

          describe '<r:shop:cart:item:delete>' do
            it 'should render an item delete' do
              @tags.push '<r:shop:cart:item:delete/>'

              pages(:home).should render(@tags.to_s).as %{<form action='/shop/cart/items/#{@product.id}' method='post'><input type='hidden' name='_method' value='put' /><input type='hidden' name='shop_line_item[product_id]' value='#{@product.id}' /><a href='/shop/cart/items/#{@product.id}/remove' title='Remove crusty bread'>Remove</a><input type='submit' name='update_item' id='update_item#{@product.id}' value='Update' /></form>}
            end
          end

          describe '<r:shop:cart:item>' do
            before :each do
              @tags.push %{<r:shop:cart:item product_id="#{@product.id}">}, '</r:shop:cart:item>'
            end

            it 'should print an item' do
              pages(:home).should render(@tags.to_s).as %{<form action='/shop/cart/items/#{@product.id}' method='post'><input type='hidden' name='_method' value='put' /><input type='hidden' name='shop_line_item[product_id]' value='#{@product.id}' /><input type='submit' name='update_item' id='update_item#{@product.id}' value='Update' /></form>}
            end
          end
        end

      end
    end

    describe '<r:shop:product>' do
      before :each do
        @tags.push %{<r:shop:product>}, '</r:shop:product>'
      end

      it 'should render a product form' do
        pages(:home).should render(@tags.to_s).as ''
      end
    end
  end
end
