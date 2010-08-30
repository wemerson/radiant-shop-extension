class ShopLineItem < ActiveRecord::Base
  
  belongs_to :order,      :class_name => 'ShopOrder', :foreign_key => :shop_order_id
  belongs_to :product,    :class_name => 'ShopProduct', :foreign_key => :shop_product_id
  
  validates_uniqueness_of :shop_product_id, :scope => :shop_order_id
  
  before_validation       :adjust_quantity
  
  def price
    product.price.to_f * self.quantity.to_f rescue 'Unable to calculate the price of the Product'
  end
  
  def weight
    product.weight.to_f * self.quantity.to_f rescue 'Unable to calculate the weight of the Product'
  end
  
private
  
  def adjust_quantity
    self.quantity = 1 if self.quantity.nil? || self.quantity < 1
  end
  
end
