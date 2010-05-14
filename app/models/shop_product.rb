class ShopProduct < ActiveRecord::Base
  default_scope :order => 'position ASC'
  
  belongs_to :category, :class_name => 'ShopCategory'
  acts_as_list :scope => :category
  
  has_many :line_items, :class_name => 'ShopLineItem', :foreign_key => 'product_id'
  has_many :orders, :class_name => 'ShopOrder', :foreign_key => 'order_id', :through => :line_items
  
  has_many :images, :class_name => 'ShopProductImage', :foreign_key => 'product_id', :order => 'shop_product_images.position ASC'
  has_many :assets, :through => :images, :uniq => :true
  
  before_validation :set_handle_and_sku
  before_validation :filter_handle_and_sku
  
  validates_presence_of :title
  validates_presence_of :sku
  validates_presence_of :handle
  validates_presence_of :category
  
  validates_uniqueness_of :title 
  validates_uniqueness_of :sku
  validates_uniqueness_of :handle
  
  validates_numericality_of :price, :greater_than => 0.00, :allow_nil => true, :precisions => 2

  def custom=(values)
    values.each do |key, value|
      self.json_field_set(key, value)
    end
  end

  def self.search(search)
    unless search.blank?
      queries = []
      queries << 'LOWER(title) LIKE (:term)'
      queries << 'LOWER(handle) LIKE (:term)'
      queries << 'LOWER(sku) LIKE (:term)'
      queries << 'LOWER(description) LIKE (:term)'
      
      sql = queries.join(" OR ")
      @conditions = [sql, {:term => "%#{search.downcase}%" }]
    else
      @conditions = []
    end
    options = { :conditions => @conditions }
    self.all(options)
  end

private

  def filter_handle_and_sku
    unless self.title.nil?
      self.handle = self.handle.downcase.gsub(/[^-a-z0-9~\s\.:;+=_]/, '').strip.gsub(/[\s\.:;=+]+/, '-')
      self.sku = self.sku.downcase.gsub(/[^-a-z0-9~\s\.:;+=_]/, '').strip.gsub(/[\s\.:;=+]+/, '-')
    end
  end

  def set_handle_and_sku
    unless self.title.nil?
      self.handle = self.title if self.handle.nil? or self.handle.empty?
      self.sku = self.title if self.sku.nil? or self.sku.empty?
    end
  end

end
