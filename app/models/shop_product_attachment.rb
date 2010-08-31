class ShopProductAttachment < ActiveRecord::Base
  
  default_scope :order => 'position ASC'
  
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
      [ :id, :title, :caption, :asset_file_name, :asset_content_type, :asset_file_size, :original_extension ]
    end
    
  end
  
end