class ShopGroupsDataset < Dataset::Base  

  uses :shop_products
  
  def load
    create_record :shop_groups, :breakfast,
      :name => 'breakfast'
    
    shop_groups(:breakfast).products = [
      shop_products(:crusty_bread),
      shop_products(:choc_milk)
    ]
  end
  
end