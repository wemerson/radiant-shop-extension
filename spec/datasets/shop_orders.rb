class ShopOrdersDataset < Dataset::Base
  
  uses :shop_products
  
  def load
    create_record :shop_order, :empty
    create_record :shop_order, :one_item
    create_record :shop_order, :several_items
    
    create_record :shop_line_item, :crusty_bread, :product => shop_products(:crusty_bread)
    create_record :shop_line_item, :soft_bread, :product => shop_products(:soft_bread)
    create_record :shop_line_item, :choc_milk, :product => shop_products(:choc_milk)
    create_record :shop_line_item, :full_milk, :product => shop_products(:full_milk)
    
    shop_orders(:one_item).line_items << shop_line_items(:crusty_bread)
    
    shop_orders(:several_items).line_items << shop_line_items(:soft_bread)
    shop_orders(:several_items).line_items << shop_line_items(:choc_milk)
    shop_orders(:several_items).line_items << shop_line_items(:full_milk)
  end
end
