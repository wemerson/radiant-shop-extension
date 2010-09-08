require 'spec/spec_helper'

describe ShopLineItem do
  
  dataset :shop_line_items

  it 'should calculate a weight' do
    shop_line_items(:one).weight.should === 31.0
    shop_line_items(:two).weight.should === 62.0
  end

  it 'should calculate the price' do
    shop_line_items(:one).price.should === 11.0
    shop_line_items(:two).price.should === 22.0
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