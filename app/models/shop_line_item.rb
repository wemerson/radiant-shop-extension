class ShopLineItem < ActiveRecord::Base
  belongs_to :order, :class_name => 'ShopOrder'
  belongs_to :product, :class_name => 'ShopProduct'
end
