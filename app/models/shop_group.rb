class ShopGroup < ActiveRecord::Base
    
  belongs_to  :created_by,  :class_name => 'User'
  belongs_to  :updated_by,  :class_name => 'User'
  
  has_many :groupings,  :class_name => 'ShopGrouping',  :foreign_key  => :group_id
  has_many :products,   :class_name => 'ShopProduct',   :through      => :groupings
  
  validates_presence_of :name
  
  def available_products
    ShopProduct.all - self.products
  end
  
end