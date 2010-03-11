class ShopOrder < ActiveRecord::Base
  has_many :products, :class_name => 'ShopProduct'
  belongs_to :shop_customer

end
