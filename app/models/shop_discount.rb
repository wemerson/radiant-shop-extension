class ShopDiscount < ActiveRecord::Base
  
  belongs_to  :created_by,  :class_name => 'User'
  belongs_to  :updated_by,  :class_name => 'User'
  
  has_many    :discountables, :class_name => 'ShopDiscountable', :foreign_key  => :discount_id
  has_many    :categories,    :through => :discountables, :source => :category, :conditions => "shop_discountables.discounted_type = 'ShopCategory'"
  has_many    :products,      :through => :discountables, :source => :product,  :conditions => "shop_discountables.discounted_type = 'ShopProduct'"
  
  validates_presence_of     :name, :code, :amount
  validates_uniqueness_of   :name, :code
  validates_numericality_of :amount
    
end