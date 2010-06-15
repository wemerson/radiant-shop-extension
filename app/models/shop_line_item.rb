class ShopLineItem < ActiveRecord::Base
  
  belongs_to :order, :class_name => 'ShopOrder', :foreign_key => :order_id
  belongs_to :product, :class_name => 'ShopProduct', :foreign_key => :product_id
  
  validates_uniqueness_of :product_id, :scope => :order_id
  
end
