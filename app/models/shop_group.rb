class ShopGroup < ActiveRecord::Base
  
  has_many :groupings,  :class_name => 'ShopGrouping',  :foreign_key  => :group_id
  has_many :products,   :class_name => 'ShopProduct',   :through      => :groupings
  
  validates_presence_of :name
  
end