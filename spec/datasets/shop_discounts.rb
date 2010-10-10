class ShopDiscountsDataset < Dataset::Base  
  
  def load
    create_record :shop_discounts, :ten_percent,
      :name   => 'ten percent',
      :code   => '10pcoff',
      :amount => 10.00
      
    create_record :shop_discounts, :five_percent,
      :name   => 'five percent',
      :code   => '5pcoff',
      :amount => 10.00
      
  end
  
end