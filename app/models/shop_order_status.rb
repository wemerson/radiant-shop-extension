class ShopOrderStatus < ActiveRecord::Base
  
  has_many :orders, :class_name => 'ShopOrder'
  
end