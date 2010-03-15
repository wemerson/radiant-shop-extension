class ShopOrder < ActiveRecord::Base
  has_many :products, :class_name => 'ShopProduct'
  belongs_to :customer, :class_name => 'ShopCustomer'

	validates_associated :products, :customer

end
