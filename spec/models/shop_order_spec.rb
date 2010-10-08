require 'spec/spec_helper'

describe ShopOrder do

  dataset :shop_orders, :shop_line_items, :shop_products, :shop_packages, :shop_payments

  context 'instance' do
    describe 'accessors' do
      it 'should return the total items' do
        shop_orders(:empty).quantity.should         === shop_orders(:empty).line_items.sum(:quantity)
        shop_orders(:one_item).quantity.should      === shop_orders(:one_item).line_items.sum(:quantity)
        shop_orders(:several_items).quantity.should === shop_orders(:several_items).line_items.sum(:quantity)
      end

      it 'should calculate a total weight' do
        shop_orders(:empty).weight.should           === lambda{ weight = 0; shop_orders(:empty).line_items.map { |l| weight += l.weight }; weight }.call
        shop_orders(:one_item).weight.should        === lambda{ weight = 0; shop_orders(:one_item).line_items.map { |l| weight += l.weight }; weight }.call
        shop_orders(:several_items).weight.should   === lambda{ weight = 0; shop_orders(:several_items).line_items.map { |l| weight += l.weight }; weight }.call
      end

      it 'should calculate the total price' do
        shop_orders(:empty).price.should            === lambda{ price = 0; shop_orders(:empty).line_items.map { |l| price += l.price }; price }.call
        shop_orders(:one_item).price.should         === lambda{ price = 0; shop_orders(:one_item).line_items.map { |l| price += l.price }; price }.call
        shop_orders(:several_items).price.should    === lambda{ price = 0; shop_orders(:several_items).line_items.map { |l| price += l.price }; price }.call
      end
      
      describe '#new?' do
        context 'success' do
          it 'should return true' do
            shop_orders(:one_item).update_attribute(:status, 'new')
            shop_orders(:one_item).new?.should === true
          end
        end
        context 'failure' do
          it 'should return false' do
            shop_orders(:one_item).update_attribute(:status, 'paid')
            shop_orders(:one_item).new?.should === false

            shop_orders(:one_item).update_attribute(:status, 'shipped')
            shop_orders(:one_item).new?.should === false
          end
        end
      end
      describe '#shipped?' do
        context 'success' do
          it 'should return true' do
            shop_orders(:one_item).update_attribute(:status, 'shipped')
            shop_orders(:one_item).shipped?.should === true
          end
        end
        context 'failure' do
          it 'should return false' do
            shop_orders(:one_item).update_attribute(:status, 'new')
            shop_orders(:one_item).shipped?.should === false

            shop_orders(:one_item).update_attribute(:status, 'paid')
            shop_orders(:one_item).shipped?.should === false
          end
        end
      end
      describe '#paid?' do
        context 'success' do
          it 'should return true' do
            shop_orders(:several_items).update_attribute(:status, 'paid')
            
            shop_orders(:several_items).payment.should  === shop_payments(:visa)
            shop_orders(:several_items).paid?.should    === true
          end
        end
        context 'failure' do
          describe 'status is not paid' do
            it 'should return false' do
              shop_orders(:several_items).update_attribute(:status, 'new')
              shop_orders(:several_items).paid?.should === false
            end
          end
          describe 'payment is nil' do
            it 'should return false' do
              shop_orders(:several_items).update_attribute(:status, 'paid')
              shop_orders(:several_items).payment = nil
              shop_orders(:several_items).paid?.should === false
            end
          end
          describe 'payment amount doesnt match' do
            it 'should return false' do
              shop_orders(:several_items).update_attribute(:status, 'paid')
              shop_orders(:several_items).payment.update_attribute(:amount, 11.00)
              shop_orders(:several_items).paid?.should === false
            end
          end
        end
      end
    end
  
    describe 'mutators' do
      describe '#add!' do   
        context 'item not in cart' do
          before :each do
            @order = shop_orders(:empty)
            @product = shop_products(:crusty_bread)
          end
          context 'no quantity or type passed' do
            it 'should assign a default type and default quantity' do
              @order.add!(@product.id)
              
              @order.line_items.count.should           === 1
              @order.line_items.first.item_type.should === 'ShopProduct'
              @order.line_items.first.quantity.should  === 1
              @order.line_items.first.item.should      === @product
            end
          end
          context 'quantity passed' do
            it 'should assign the default type and new quantity' do
              @order.add!(@product.id, 2)
              
              @order.line_items.count.should           === 1
              @order.line_items.first.item_type.should === 'ShopProduct'
              @order.line_items.first.quantity.should  === 2
              @order.line_items.first.item.should      === @product              
            end
          end
          context 'type and quantity passed' do
            it 'should assign the new type and new quantity' do
              @order.add!(shop_packages(:all_bread).id, 2, 'ShopPackage')
              
              @order.line_items.count.should           === 1
              @order.quantity.should                   === 2
              @order.line_items.first.item_type.should === 'ShopPackage'
            end
          end
        end
        context 'item in cart' do
          before :each do
            @order      = shop_orders(:one_item)
            @line_item  = @order.line_items.first
          end
          context 'no quantity or type passed' do
            it 'should assign a default type and default quantity' do
              @order.add!(@line_item.id)
              
              @order.line_items.count.should === 1
              @order.quantity.should         === 1
            end
          end
          context 'quantity passed' do
            it 'should assign the default type and new quantity' do
              @order.add!(@line_item.id, 2)
              
              @order.line_items.count.should === 1
              @order.quantity.should         === 3
            end
          end
        end
      end
      describe '#modify!' do
        context 'quantity not set' do
          before :each do
            @order = shop_orders(:one_item)
            @line_item = @order.line_items.first
          end
          it 'should not update the item' do
            @order.modify!(@line_item.id)
            
            @order.quantity.should === 1
          end
        end
        context 'quantity set' do
          before :each do
            @order = shop_orders(:one_item)
            @line_item = @order.line_items.first
          end
          context 'quantity > 0' do
            it 'should assign that quantity' do
              @order.modify!(@line_item.id, 1)
              @order.quantity.should === 1
              
              @order.modify!(@line_item.id, 2)
              @order.quantity.should === 2
              
              @order.modify!(@line_item.id, 100)
              @order.quantity.should === 100
            end
          end
          context 'quantity <= 0' do
            it 'should remove that item for 0' do
              @order.modify!(@line_item.id, 0)
              @order.quantity.should === 0         
            end
            it 'should remove that item for -1' do
              @order.modify!(@line_item.id, -1)
              @order.quantity.should === 0
            end
            it 'should remove that item for -100' do
              @order.modify!(@line_item.id, -100)
              @order.quantity.should === 0
            end
          end
        end
      end
      describe '#remove!' do
        it 'should remove the item' do
          @order = shop_orders(:several_items)
          items = @order.line_items.count
          
          @order.remove!(@order.line_items.first.id)
          @order.line_items.count.should === items - 1
        end
      end
      describe '#clear!' do
        it 'should remove all items' do
          @order = shop_orders(:several_items)
          @order.clear!
          @order.quantity.should === 0
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
