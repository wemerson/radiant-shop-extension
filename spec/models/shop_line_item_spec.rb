require 'spec/spec_helper'

describe ShopLineItem do
  
  dataset :shop_line_items

  it 'should calculate a weight' do
    shop_line_items(:one).weight.should === (shop_line_items(:one).item.weight * shop_line_items(:one).quantity).to_f
    shop_line_items(:two).weight.should === (shop_line_items(:two).item.weight * shop_line_items(:two).quantity).to_f
  end

  it 'should calculate the price' do
    shop_line_items(:one).price.should === (shop_line_items(:one).item.price * shop_line_items(:one).quantity).to_f
    shop_line_items(:two).price.should === (shop_line_items(:two).item.price * shop_line_items(:two).quantity).to_f
  end
  
  it 'should have a set of standard parameters' do
    ShopLineItem.params.should === [
      :id,
      :quantity
    ]
  end
  
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