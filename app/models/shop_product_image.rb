class ShopProductImage < ActiveRecord::Base
  
  belongs_to :product, :class_name => 'ShopProduct'
  belongs_to :product_image, :class_name => 'ShopProductImage'
  
  acts_as_list :scope => :product_id
  
end