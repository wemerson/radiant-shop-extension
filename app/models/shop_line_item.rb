class ShopLineItem < ActiveRecord::Base
  
  belongs_to :order,      :class_name => 'ShopOrder', :foreign_key => :shop_order_id
  belongs_to :item,       :polymorphic => true
  
  validates_uniqueness_of :item_id, :scope => [ :shop_order_id, :item_type ]
  
  before_validation       :adjust_quantity
  
  def price
    item.price.to_f * self.quantity.to_f
  end
  
  def weight
    item.weight.to_f * self.quantity.to_f
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
