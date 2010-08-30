class ShopPayment < ActiveRecord::Base
  
  belongs_to :order,  :class_name => 'ShopOrder', :foreign_key => :shop_order_id
  belongs_to :method, :class_name => 'ShopPaymentMethod', :foreign_key => :shop_payment_method_id
  
end
