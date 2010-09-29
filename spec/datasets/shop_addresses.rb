class ShopAddressesDataset < Dataset::Base
  def load
    # TODO Investigate why inflectors are breaking here
    create_record :shop_addresss, :billing,
      :name   => 'Billing Address',
      :email  => 'billing@address.com',
      :unit   => 'a',
      :street => '1 Bill Street',
      :city   => 'Billvilles',
      :state  => 'BI',
      :country=> 'Billington',
      :postcode=> '1234'
      
    create_record :shop_addresss, :shipping,
      :name   => 'Shipping Address',
      :email  => 'shipping@address.com',
      :unit   => 'b',
      :street => '2 Ship Street',
      :city   => 'Shipvilles',
      :state  => 'SH',
      :country=> 'Shippington',
      :postcode=> '1234'
  end
end
