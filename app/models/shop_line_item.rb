class ShopLineItem < ActiveRecord::Base
  
  belongs_to :order,      :class_name => 'ShopOrder'
  belongs_to :product,    :class_name => 'ShopProduct'
  
  validates_uniqueness_of :product_id, :scope => :order_id
  
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
