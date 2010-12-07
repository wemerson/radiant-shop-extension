class ShopOrdersDataset < Dataset::Base
  
  uses :shop_products, :shop_customers
  
  def load
    create_record :shop_order, :empty
    
    create_record :shop_order, :one_item,
      :customer => shop_customers(:customer)
          
    create_record :shop_order, :several_items,
      :customer => shop_customers(:customer)
  end
end
