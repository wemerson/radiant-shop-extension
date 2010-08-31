class ShopProductAttachment < ActiveRecord::Base
  
  default_scope :order => 'position ASC'
  
  belongs_to    :product,   :class_name => 'ShopProduct', :foreign_key => :shop_product_id
  belongs_to    :image
  
  acts_as_list  :scope =>   :shop_product
  
  def url(*params)
    image.url(*params)
  end
  
  def title(*params)
    image.title(*params)
  end
  
  def caption(*params)
    image.caption(*params)
  end
  
end