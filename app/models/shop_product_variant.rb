class ShopProductVariant < ActiveRecord::Base
  
  belongs_to :product, :class_name => 'ShopProduct', :foreign_key => 'product_id'
  
  validates_presence_of :product
  validates_presence_of :name
  
  belongs_to :created_by, :class_name => 'User'
  belongs_to :updated_by, :class_name => 'User'
  
  # Returns the price of the variant plus the product price
  def price
    price = self.product.price
    if self.read_attribute(:price).present?
      price = self.read_attribute(:price) + self.product.price
    end
    price
  end
  
  # Returns a mixed sku of product and variant name
  def sku
    
  end
  
  # Returns link to product
  def link
    
  end
  
end