require 'spec/spec_helper'

describe ShopLineItem do
  
  dataset :shop_line_items, :shop_products
  
  context 'methods' do
  
    describe '#weight' do
      it 'should multiple weight by quanttiy' do
        shop_line_items(:one).weight.should === (shop_line_items(:one).item.weight * shop_line_items(:one).quantity).to_f
        shop_line_items(:two).weight.should === (shop_line_items(:two).item.weight * shop_line_items(:two).quantity).to_f
      end
    end
  
    describe '#price' do
      it 'should multiple price by quantity' do
        shop_line_items(:one).price.should === (shop_line_items(:one).item.price * shop_line_items(:one).quantity).to_f
        shop_line_items(:two).price.should === (shop_line_items(:two).item.price * shop_line_items(:two).quantity).to_f
      end
    end
  
    describe '#to_json' do
      it 'should overload standard to_json' do
        pending 'not sure how to write this'
      end
    end
    
  end
  
  context 'filters' do
    
    describe '#adjust_quantity' do
      it 'should adjust quantity to 1 if less than' do
        s = ShopLineItem.new({ :item => shop_products(:crusty_bread), :quantity => 0 })
        s.valid?
        s.quantity.should === 1

        s = ShopLineItem.new({ :item => shop_products(:crusty_bread), :quantity => 1 })
        s.valid?
        s.quantity.should === 1

        s = ShopLineItem.new({ :item => shop_products(:crusty_bread), :quantity => -100 })
        s.valid?
        s.quantity.should === 1

        s = ShopLineItem.new({ :item => shop_products(:crusty_bread), :quantity => 100 })
        s.valid?
        s.quantity.should === 100
      end
    end
  end
  
  describe '#attrs' do
    it 'should return attribute set' do
      ShopLineItem.attrs.should === [ :id, :quantity ]
    end
  end
  
  describe '#methds' do
    it 'should return method set' do
      ShopLineItem.methds.should === [ :price, :weight ]
    end
  end
  
  describe '#params' do
    it 'should return parameter set' do
      ShopLineItem.params.should === { :only => ShopLineItem.attrs, :methods => ShopLineItem.methds }
    end
  end
  
end