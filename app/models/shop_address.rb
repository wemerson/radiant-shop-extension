class ShopAddress < ActiveRecord::Base
  
  has_one :billing,     :class_name => 'ShopAddressBilling', :foreign_key => :shop_address_billing_id
  has_one :shipping,    :class_name => 'ShopAddressShipping', :foreign_key => :shop_address_shipping_id

  validates_presence_of :name
  validates_presence_of :street
  validates_presence_of :city
  validates_presence_of :postcode
  validates_presence_of :state  
  validates_presence_of :country
    
end
