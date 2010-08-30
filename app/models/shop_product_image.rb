class ShopProductImage < ActiveRecord::Base
  
  default_scope :order => 'position ASC'
  
  belongs_to    :product,  :class_name => 'ShopProduct'
  belongs_to    :image,    :class_name => 'Image'

  acts_as_list  :scope => :product_id
  
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