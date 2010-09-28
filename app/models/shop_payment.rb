class ShopPayment < ActiveRecord::Base
  
  belongs_to :order,  :class_name => 'ShopOrder', :foreign_key => :shop_order_id
  
end
