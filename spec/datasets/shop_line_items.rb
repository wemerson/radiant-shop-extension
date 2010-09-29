class ShopLineItemsDataset < Dataset::Base
  
  uses :shop_products, :shop_orders
  
  def load
    create_record :shop_line_item, :one,    :item_id => shop_products(:crusty_bread).id,  :order => shop_orders(:one_item),       :item_type => 'ShopProduct'
    create_record :shop_line_item, :two,    :item_id => shop_products(:soft_bread).id,    :order => shop_orders(:several_items),  :item_type => 'ShopProduct',  :quantity => 2
    create_record :shop_line_item, :three,  :item_id => shop_products(:choc_milk).id,     :order => shop_orders(:several_items),  :item_type => 'ShopProduct',  :quantity => 3
  end
end
