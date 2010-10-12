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
    price = value
    price -= discounted
    
    # We never want to return a negative cost
    [0.00,price.to_f].max
  end
  
  def value
    price = (item.price * self.quantity)
  end
  
  def discounted
    (item.price * self.quantity * discount)
  end
  
  def weight
    (item.weight.to_f * self.quantity.to_f).to_f
  end
  
  def discount
    discount = BigDecimal.new('0.00')
    self.discounts.map { |d| discount += d.amount }
    
    # Convert to a percentage
    discount * 0.01
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
