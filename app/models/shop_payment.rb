class ShopPayment < ActiveRecord::Base
  belongs_to :order, :class_name => 'ShopOrder'
end
