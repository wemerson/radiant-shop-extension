class ShopAddressShipping < ActiveRecord::Base
  
  has_many :addressables, :as => :addresser
  has_many :orders,       :through => :addressables, :source => :addresser, :class_name => 'ShopOrder',     :uniq => true
  has_many :customers,    :through => :addressables, :source => :addresser, :class_name => 'ShopCustomer',  :uniq => true
  
  belongs_to  :address,   :class_name => 'ShopAddress', :foreign_key => :shop_address_id
  belongs_to  :customer,  :class_name => 'ShopCustomer', :foreign_key => :shop_customer_id
  
  accepts_nested_attributes_for :address
  
end