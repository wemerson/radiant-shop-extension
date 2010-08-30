class ShopPayment < ActiveRecord::Base
  
  belongs_to :order,  :class_name => 'ShopOrder'
  belongs_to :method, :class_name => 'ShopPaymentMethod'
  
end
