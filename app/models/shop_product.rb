class ShopProduct < ActiveRecord::Base
  
  default_scope :order => 'position ASC'
  acts_as_list :scope =>  :category
  
  belongs_to :created_by, :class_name => 'User'
  belongs_to :updated_by, :class_name => 'User'  
  belongs_to :category,   :class_name => 'ShopCategory'
  
  has_many :line_items,     :class_name => 'ShopLineItem',  :foreign_key => 'product_id'
  has_many :orders,         :class_name => 'ShopOrder',     :foreign_key => 'order_id', :through => :line_items
  
  has_many :product_images, :class_name => 'ShopProductImage', :foreign_key => 'product_id'
  has_many :images,         :through => :product_images, :uniq => true
  
  before_validation     :set_sku
  before_validation     :filter_sku
  
  validates_presence_of :name
  validates_presence_of :sku
  validates_presence_of :category
  
  validates_uniqueness_of :name
  validates_uniqueness_of :sku
  
  validates_numericality_of :price, :greater_than => 0.00, :allow_nil => true, :precisions => 2

  def self.find_by_handle(handle)
    first(:conditions => ['LOWER(sku) = ?', handle])
  end
  
  def handle
    self.sku
  end
  
  def slug
    self.slug_prefix + '/' + self.category.handle + '/' + self.handle
  end

  def layout
    self.category.product_layout
  end

  def images_available
    Image.search() - self.images
  end
  
  def slug_prefix
    Radiant::Config['shop.url_prefix']
  end

  class << self
    
    def search(search)
      unless search.blank?
        queries = []
        queries << 'LOWER(title) LIKE (:term)'
        queries << 'LOWER(sku) LIKE (:term)'
        queries << 'LOWER(description) LIKE (:term)'
      
        sql = queries.join(" OR ")
        conditions = [sql, {:term => "%#{search.downcase}%" }]
      else
        conditions = []
      end
    
      self.all({ :conditions => conditions })
    end
    
    def params
      [ :id, :name, :price, :sku, :handle, :description, :created_at, :updated_at ]
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
    
    if self.handle.nil?
      self.handle = self.sku
    end
  end
  
end
