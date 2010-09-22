class ShopAddress < ActiveRecord::Base
  
  has_many :shipping_orders,  :class_name => 'ShopOrder', :foreign_key => :shipping_id
  has_many :billing_orders,   :class_name => 'ShopOrder', :foreign_key => :billing_id
  
  validates_presence_of :name
  validates_presence_of :street
  validates_presence_of :city
  validates_presence_of :postcode
  validates_presence_of :state  
  validates_presence_of :country
    
end
