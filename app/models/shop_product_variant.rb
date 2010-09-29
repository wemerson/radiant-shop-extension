class ShopProductVariant < ActiveRecord::Base
  
  belongs_to :product, :class_name => 'ShopProduct', :foreign_key => 'product_id'
  
  validates_presence_of :product
  validates_presence_of :name
  validates_presence_of :price
  
end