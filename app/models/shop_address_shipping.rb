class ShopAddressShipping < ActiveRecord::Base
  
  has_many :addressables, :as => :addresser
  
  has_many :orders, :through => :addressables, :source => :addresser, :class_name => 'ShopOrder', :uniq => true
  has_many :customers, :through => :addressables, :source => :addresser, :class_name => 'ShopCustomer', :uniq => true
  
  belongs_to  :address
  belongs_to  :customer
  
  accepts_nested_attributes_for :address
  
end