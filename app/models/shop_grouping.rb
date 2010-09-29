class ShopGrouping < ActiveRecord::Base
  
  belongs_to :group, :class_name => 'ShopGroup'
  
end