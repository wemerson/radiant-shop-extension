class ShopProduct < ActiveRecord::Base
  
  default_scope             :order => 'shop_products.position ASC'
  
  belongs_to  :created_by,  :class_name => 'User'
  belongs_to  :updated_by,  :class_name => 'User'
  belongs_to  :category,    :class_name => 'ShopCategory', :foreign_key => :shop_category_id
  
  has_many    :line_items,  :class_name => 'ShopLineItem', :as => :item
  has_many    :packings,    :class_name => 'ShopPackings'
  has_many    :orders,      :class_name => 'ShopOrder', :through => :line_items
  has_many    :attachments, :class_name => 'ShopProductAttachment'
  has_many    :images,      :through => :attachments,  :uniq => true
  
  before_validation         :set_sku, :filter_sku
  
  validates_presence_of     :name, :sku, :category
  
  validates_uniqueness_of   :name, :sku
  
  validates_numericality_of :price, :greater_than => 0.00, :allow_nil => true, :precisions => 2
  
  acts_as_list              :scope =>  :shop_category
  
  def slug
    "/#{self.slug_prefix}/#{self.category.handle}/#{self.sku}"
  end
  
  def layout
    self.category.product_layout
  end
  
  def available_images
    Image.all - self.images
  end
  
  def slug_prefix
    Radiant::Config['shop.url_prefix']
  end
  
  class << self
    
    def search(search)
      unless search.blank?
        queries = []
        queries << 'LOWER(title)        LIKE (:term)'
        queries << 'LOWER(sku)          LIKE (:term)'
        queries << 'LOWER(description)  LIKE (:term)'
        
        sql = queries.join(" OR ")
        conditions = [sql, {:term => "%#{search.downcase}%" }]
      else
        conditions = []
      end
      
      self.all({ :conditions => conditions })
    end
    
    def params
      [ :id, :name, :price, :sku, :description, :created_at, :updated_at ]
    end
    
  end
  
private
  
  def set_sku
    unless self.name.nil?
      self.sku = self.name if self.sku.nil? or self.sku.empty?
    end
  end
  
  def filter_sku
    unless self.name.nil?
      self.sku = self.sku.downcase.gsub(/[^-a-z0-9~\s\.:;+=_]/, '').strip.gsub(/[\s\.:;=+~]+/, '-')
    end
  end
  
end
