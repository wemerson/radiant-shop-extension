class ShopProductAttachment < ActiveRecord::Base
  
  default_scope :order => 'shop_product_attachments.position ASC'
  
  belongs_to    :product,   :class_name => 'ShopProduct', :foreign_key => :shop_product_id
  belongs_to    :image
  
  acts_as_list  :scope =>   :shop_product
  
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