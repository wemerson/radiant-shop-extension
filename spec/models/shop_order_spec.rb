require 'spec/spec_helper'

describe ShopOrder do

  dataset :shop_orders, :shop_line_items, :shop_products

  context 'instance' do
    describe 'accessors' do
      it 'should return the total items' do
        shop_orders(:empty).quantity.should === 0
        shop_orders(:one_item).quantity.should === 1
        shop_orders(:several_items).quantity.should === 3
      end

      it 'should calculate a total weight' do
        shop_orders(:empty).weight.should === 0
        shop_orders(:one_item).weight.to_f.should === 31.0
        shop_orders(:several_items).weight.to_f.should === 276.0
      end

      it 'should calculate the total price' do
        shop_orders(:empty).price.should === 0
        shop_orders(:one_item).price.to_f.should === 11.0
        shop_orders(:several_items).price.to_f.should === 96.0
      end
    end
  
    describe 'mutators' do
      describe '#add!' do   
        context 'item not in cart' do
          before :each do
            @shop_order = shop_orders(:empty)
            @shop_product = shop_products(:crusty_bread)
          end
          context 'no quantity or type passed' do
            it 'should assign a default type and default quantity' do
              @shop_order.add!(@shop_product.id)
              
              @shop_order.line_items.count.should == 1
              @shop_order.line_items.first.item_type.should === 'ShopProduct'
              @shop_order.line_items.first.quantity.should === 1
              @shop_order.line_items.first.item.should === @shop_product
            end
          end
          context 'quantity passed' do
            it 'should assign the default type and new quantity' do
              @shop_order.add!(@shop_product.id, 2)
              
              @shop_order.line_items.count.should === 1
              @shop_order.line_items.first.item_type.should === 'ShopProduct'
              @shop_order.line_items.first.quantity.should === 2
              @shop_order.line_items.first.item.should === @shop_product              
            end
          end
          context 'type and quantity passed' do
            it 'should assign the new type and new quantity' do
              @shop_order.add!(@shop_product.id, 2, 'ShopPackage')
              
              @shop_order.line_items.count.should === 1
              @shop_order.quantity.should === 2
              @shop_order.line_items.first.item_type.should === 'ShopPackage'
            end
          end
        end
        context 'item in cart' do
          before :each do
            @shop_order = shop_orders(:one_item)
            @shop_line_item = shop_orders(:one_item).line_items.first
          end
          context 'no quantity or type passed' do
            it 'should assign a default type and default quantity' do
              @shop_order.add!(@shop_line_item.id)
              
              @shop_order.line_items.count.should === 1
              @shop_order.quantity.should === 2
            end
          end
          context 'quantity passed' do
            it 'should assign the default type and new quantity' do
              @shop_order.add!(@shop_line_item.id, 2)
              
              @shop_order.line_items.count.should === 1
              @shop_order.quantity.should === 3
            end
          end
        end
      end
      describe '#update!' do
        before :each do
          @shop_order = shop_orders(:one_item)
          @shop_line_item = shop_orders(:one_item).line_items.first
        end
        context 'quantity not set' do
          it 'should assign a quantity of 1' do
            @shop_order.update!(@shop_line_item.id)
            
            @shop_order.line_items.count.should === 1
            @shop_order.quantity.should === 1
          end
        end
        context 'quantity set' do
          context 'quantity > 0' do
            it 'should assign that quantity' do
              @shop_order.update!(@shop_line_item.id, 1)
              @shop_order.quantity.should === 1
              
              @shop_order.update!(@shop_line_item.id, 2)
              @shop_order.quantity.should === 2
              
              @shop_order.update!(@shop_line_item.id, 100)
              @shop_order.quantity.should === 100
            end
          end
          context 'quantity <= 0' do
            it 'should remove that item for 0' do
              @shop_order.update!(@shop_line_item.id, 0)
              @shop_order.quantity.should === 0
              @shop_order.line_items.count.should === 0          
            end
            it 'should remove that item for -1' do
              @shop_order.update!(@shop_line_item.id, -1)
              @shop_order.quantity.should === 0
              @shop_order.line_items.count.should === 0
            end
            it 'should remove that item for -100' do
              @shop_order.update!(@shop_line_item.id, -100)
              @shop_order.quantity.should === 0
              @shop_order.line_items.count.should === 0
            end
          end
        end
      end
      describe '#remove!' do
        it 'should remove the item' do
          @shop_order = shop_orders(:several_items)
          
          @shop_order.remove!(@shop_order.line_items.first.id)
          @shop_order.quantity.should === 2
          @shop_order.line_items.count.should === 2
        end
      end
      describe '#clear!' do
        it 'should remove all items' do
          @shop_order = shop_orders(:several_items)
          
          @shop_order.clear!
          @shop_order.quantity.should === 0
          @shop_order.line_items.count.should === 0
        end
      end
    end
  end
  
  context 'class methods' do
    describe '#search' do
      context 'status' do
        it 'should return valid subsets' do
          count = ShopOrder.count
          
          old = ShopOrder.first
          old.update_attribute(:status, 'paid')
        
          results = ShopOrder.search('new')
          results.count.should === count - 1
        end
      end
    end
    
    describe '#params' do
      it 'should have a set of standard parameters' do
        ShopOrder.params.should === [ :id, :notes, :status ]
      end
    end
  end

end
