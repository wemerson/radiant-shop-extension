class ShopLineItemsDataset < Dataset::Base
  
  uses :shop_products
  
  def load
    create_record :shop_line_item, :one, :item_id => shop_products(:crusty_bread).id, :item_type => 'ShopProduct'
    create_record :shop_line_item, :two, :item_id => shop_products(:crusty_bread).id, :item_type => 'ShopProduct', :quantity => 2
  end
end
