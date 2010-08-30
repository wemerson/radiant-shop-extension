class ShopCategory < ActiveRecord::Base
  
  default_scope :order => 'position ASC'
  
  belongs_to  :created_by,      :class_name => 'User'
  belongs_to  :updated_by,      :class_name => 'User'
  belongs_to  :layout
  belongs_to  :product_layout,  :class_name => 'Layout'
  
  has_many    :products,        :class_name => 'ShopProduct', :dependent => :destroy
  
  before_validation :set_handle, :filter_handle
  
  validates_presence_of :name, :handle
  
  validates_uniqueness_of :name, :handle
  
  acts_as_list
  
  def self.find_by_handle(handle)
    first(:conditions => ['LOWER(handle) = ?', handle])
  end
  
  def custom=(values)
    values.each do |key, value|
      self.json_field_set(key, value)
    end
  end
  
  def after_initialize
    self.custom_layout = Radiant::Config['shop.category_layout'] if self.custom_layout.nil?
    self.custom_product_layout = Radiant::Config['shop.product_layout'] if self.custom_product_layout.nil?
  end
  
  def slug
    "/#{self.slug_prefix}/#{self.handle}"
  end
  
  def slug_prefix
    Radiant::Config['shop.url_prefix']
  end
  
  class << self
  
    def search(search)
      unless search.blank?
        queries = []
        queries << 'LOWER(title) LIKE (:term)'
        queries << 'LOWER(handle) LIKE (:term)'
        queries << 'LOWER(description) LIKE (:term)'
      
        sql = queries.join(" OR ")
        conditions = [sql, {:term => "%#{search.downcase}%" }]
      else
        conditions = []
      end
      
      all({ :conditions => conditions })
    end
    
    def params
      [ :id, :handle, :description, :created_at, :updated_at ]
    end
    
  end
  
private
  
  def set_handle
    unless self.name.nil?
      self.handle = self.name if self.handle.nil? or self.handle.empty?
    end
  end
  
  def filter_handle
    unless self.name.nil?
      self.handle = self.handle.downcase.gsub(/[^-a-z0-9~\s\.:;+=_]/, '').strip.gsub(/[\s\.:;=+~]+/, '-')
    end
  end
  
end
