class ShopOrdersDataset < Dataset::Base
  
  uses :shop_products, :shop_customers, :shop_addresses
  
  def load
    create_record :shop_order, :empty
    
    create_record :shop_order, :one_item,
      :customer   => shop_customers(:customer)
          
    create_record :shop_order, :several_items,
      :customer   => shop_customers(:customer), 
      :billing    => shop_addresses(:billing),
      :shipping   => shop_addresses(:shipping)
  end
end
