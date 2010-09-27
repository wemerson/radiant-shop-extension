class ShopOrdersDataset < Dataset::Base
  
  uses :shop_products, :shop_customers, :shop_addresses
  
  def load
    create_record :shop_order, :empty
    create_record :shop_order, :one_item
    create_record :shop_order, :several_items,
      :customer => shop_customers(:customer), 
      :billing  => shop_addresses(:billing),
      :shipping => shop_addresses(:shipping)
    
    create_record :shop_line_item, :crusty_bread, :item_id => shop_products(:crusty_bread).id, :item_type => 'ShopProduct'
    create_record :shop_line_item, :soft_bread,   :item_id => shop_products(:soft_bread).id, :item_type => 'ShopProduct'
    create_record :shop_line_item, :choc_milk,    :item_id => shop_products(:choc_milk).id, :item_type => 'ShopProduct'
    create_record :shop_line_item, :full_milk,    :item_id => shop_products(:full_milk).id, :item_type => 'ShopProduct'
    
    shop_orders(:one_item).line_items       << shop_line_items(:crusty_bread)
    
    shop_orders(:several_items).line_items  << shop_line_items(:soft_bread)
    shop_orders(:several_items).line_items  << shop_line_items(:choc_milk)
    shop_orders(:several_items).line_items  << shop_line_items(:full_milk)
  end
end
