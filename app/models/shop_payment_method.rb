class ShopPaymentMethod < ActiveRecord::Base
  
  has_many :payments, :class_name => 'ShopPayment'
  
end
