class ShopAddress < ActiveRecord::Base
  
  belongs_to :customer, :class_name => 'ShopCustomer'
  has_many :shipments, :class_name => 'ShopShippingMethod', :foreign_key => 'address_id'
  has_many :billings, :class_name => 'ShopBillingMethod', :foreign_key => 'address_id'

  validates_presence_of :country
  validates_presence_of :state
  validates_presence_of :city
  validates_presence_of :street
  validates_presence_of :postal_code
  validates_presence_of :atype
  validates_format_of :atype, :with => /(shipping|billing)/i
  
end
