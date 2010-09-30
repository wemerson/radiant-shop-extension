class ShopProduct < ActiveRecord::Base
  
  default_scope             :joins => :category, :order => 'shop_categories.position, shop_products.position ASC'
    
  belongs_to  :created_by,  :class_name => 'User'
  belongs_to  :updated_by,  :class_name => 'User'
  belongs_to  :category,    :class_name => 'ShopCategory'
  
  has_many    :line_items,  :class_name => 'ShopLineItem',          :foreign_key  => :item_id,      :dependent => :destroy
  has_many    :orders,      :class_name => 'ShopOrder',             :through      => :line_items,   :uniq => true
  has_many    :attachments, :class_name => 'ShopProductAttachment', :foreign_key  => :product_id
  has_many    :images,      :class_name => 'Image',                 :through      => :attachments,  :uniq => true
  has_many    :groupings,   :class_name => 'ShopGrouping',          :foreign_key  => :product_id
  has_many    :groups,      :class_name => 'ShopGroup',             :through      => :groupings,    :uniq => true
  has_many    :related,     :class_name => 'ShopProduct',           :through      => :groupings,    :uniq => true
  has_many    :variants,    :class_name => 'ShopProductVariant',    :foreign_key  => :product_id,   :dependent => :destroy
  
  before_validation         :set_sku, :filter_sku
  validates_presence_of     :name,    :sku,     :category
  validates_uniqueness_of   :name,    :scope => :category_id
  validates_uniqueness_of   :sku
  validates_numericality_of :price,   :greater_than => 0.00,    :allow_nil => true,     :precisions => 2
  
  accepts_nested_attributes_for :variants
  
  acts_as_list              :scope =>  :category
  
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
        queries << 'LOWER(shop_products.name)         LIKE (:term)'
        queries << 'LOWER(shop_products.sku)          LIKE (:term)'
        queries << 'LOWER(shop_products.description)  LIKE (:term)'
        
        sql = queries.join(" OR ")
        conditions = [sql, {:term => "%#{search.downcase}%" }]
      else
        conditions = []
      end
      
      self.all({ :conditions => conditions })
    end
    
    def attrs
      [ :id, :name, :price, :sku, :description, :created_at, :updated_at ]
    end
    
    def params
      {
        :include  => { :category => { :only => ShopCategory.attrs } },
        :only     => ShopProduct.attrs
      }
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
      self.sku = self.sku.downcase.gsub(/[^-a-z0-9~\s\.:;+=_]/, '').strip.gsub(/[\s\.:;=+~]+/, '_')
    end
  end
  
end
