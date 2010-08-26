require 'spec/spec_helper'

describe ShopOrderTags do
  dataset :pages

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
      @shop_order = ShopOrder.create
    end

    describe '<r:shop:cart:(id|status)>' do
      [:id, :status].each do |symbol|
        it 'should output the symbol' do
          tag = %{<r:shop:cart:"#{symbol} id="#{@shop_order.id}"/>}

          pages(:home).should render(tag)
        end
      end
    end

    describe '<r:shop:cart:quantity>' do
      it 'should render the quantity' do
        tag = %{<r:shop:cart:quantity id="#{@shop_order.id}"/>}

        pages(:home).should_not render(tag)
      end

      it 'should render the quantity' do
        tag = %{<r:shop:cart:quantity id="#{@shop_order.id}"/>}

        pages(:home).should render(tag).as(@shop_order.quantity)
      end
    end

    describe '<r:shop:cart:price>' do
      it 'should display the value of the shopping cart' do
        tag = %{<r:shop:cart:price id="#{@shop_order.id}"/>}

        pages(:home).should render(tag)
      end
    end
  end
end
