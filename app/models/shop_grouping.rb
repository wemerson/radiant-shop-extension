class ShopGrouping < ActiveRecord::Base
  
  belongs_to :group,    :class_name => 'ShopGroup'
  belongs_to :product,  :class_name => 'ShopProduct'
  
end