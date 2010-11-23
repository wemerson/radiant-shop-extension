require 'acts_as_list'

class ShopProductAttachment < ActiveRecord::Base
  
  default_scope :order => 'shop_product_attachments.position ASC'
  
  belongs_to    :product,   :class_name => 'ShopProduct'
  belongs_to    :image
  
  belongs_to  :created_by,  :class_name => 'User'
  belongs_to  :updated_by,  :class_name => 'User'
  
  acts_as_list  :scope =>   :product
  
  def url(*params)
    image.url(*params) rescue nil
  end
  
  def title(*params)
    image.title(*params) rescue nil
  end
  
  def caption(*params)
    image.caption(*params) rescue nil
  end
  
  class << self
    
    def params
      [ :id, :title, :caption, :image_file_name, :image_content_type, :image_file_size ]
    end
    
  end
  
end