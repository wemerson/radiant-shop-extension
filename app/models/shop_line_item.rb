class ShopLineItem < ActiveRecord::Base
  
  belongs_to  :order,       :class_name   => 'ShopOrder'
  has_one     :customer,    :class_name   => 'ShopCustomer', :through => :order, :source => :customer
  belongs_to  :item,        :polymorphic  => true
  
  has_many :discountables, :class_name => 'ShopDiscountable', :foreign_key  => :discounted_id
  has_many   :discounts,   :class_name => 'ShopDiscount',     :through      => :discountables
  
  before_validation       :adjust_quantity
  validates_uniqueness_of :item_id, :scope => [ :order_id, :item_type ]
  validates_presence_of   :item
  
  
  def price
    item.price * self.quantity
  end
  
  def weight
    (item.weight.to_f * self.quantity.to_f).to_f
  end
  
  class << self
    
    def params
      [ :id, :quantity ]
    end
    
  end
  
private
  
  def adjust_quantity
    self.quantity = [1,self.quantity].max
  end
  
end
