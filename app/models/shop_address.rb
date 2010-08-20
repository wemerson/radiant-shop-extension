class ShopAddress < ActiveRecord::Base
  
  has_one :billing, :class_name => 'ShopAddressBilling'
  has_one :shipping, :class_name => 'ShopAddressShipping'

  validates_presence_of :street
  validates_presence_of :city
  validates_presence_of :postcode
  validates_presence_of :state  
  validates_presence_of :country
    
end
