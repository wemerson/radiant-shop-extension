class ShopPayment < ActiveRecord::Base
  
  belongs_to :order,  :class_name => 'ShopOrder', :foreign_key => :shop_order_id
  
  validates_length_of :card_number, :maximum => 4
  
end
