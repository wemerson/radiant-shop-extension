class ShopAddressesDataset < Dataset::Base
  
  uses :shop_orders
  
  def load
    create_record :shop_billing, :order_billing,
      :name             => 'Billing Address',
      :email            => 'billing@address.com',
      :unit             => 'a',
      :street           => '1 Bill Street',
      :city             => 'Billvilles',
      :state            => 'BI',
      :country          => 'Billington',
      :of_type          => 'billing',
      :postcode         => '1234',
      :addressable_id   => shop_orders(:several_items).id,
      :addressable_type => 'ShopOrder'

      
    create_record :shop_shipping, :order_shipping,
      :name             => 'Shipping Address',
      :email            => 'shipping@address.com',
      :unit             => 'b',
      :street           => '2 Ship Street',
      :city             => 'Shipvilles',
      :state            => 'SH',
      :country          => 'Shippington',
      :of_type          => 'shipping',
      :postcode         => '1234',
      :addressable_id   => shop_orders(:several_items).id,
      :addressable_type => 'ShopOrder'
  end
end
