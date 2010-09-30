class ShopCategory < ActiveRecord::Base
  
  default_scope :order => 'shop_categories.position ASC'
  
  belongs_to  :created_by,      :class_name => 'User'
  belongs_to  :updated_by,      :class_name => 'User'
  belongs_to  :layout,          :class_name => 'Layout'
  belongs_to  :product_layout,  :class_name => 'Layout'
  belongs_to  :variant,         :class_name => 'ShopVariant'
  
  has_many    :products,        :class_name => 'ShopProduct', :foreign_key => :category_id, :dependent => :destroy
  
  before_validation             :set_handle, :filter_handle, :set_layouts
  validates_presence_of         :name, :handle
  validates_uniqueness_of       :name, :handle
  
  acts_as_list

  def custom=(values)
    values.each do |key, value|
      self.json_field_set(key, value)
    end
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
        queries << 'LOWER(shop_categories.name)         LIKE (:term)'
        queries << 'LOWER(shop_categories.handle)       LIKE (:term)'
        queries << 'LOWER(shop_categories.description)  LIKE (:term)'
      
        sql = queries.join(" OR ")
        conditions = [sql, {:term => "%#{search.downcase}%" }]
      else
        conditions = []
      end
      
      all({ :conditions => conditions })
    end
    
    def attrs
      [ :id, :handle, :description, :created_at, :updated_at ]
    end
    
    def params
      {
        :include  => { :products => { :only => ShopProduct.attrs } },
        :only     => ShopCategory.attrs
      }
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
      self.handle = self.handle.downcase.gsub(/[^-a-z0-9~\s\.:;+=_]/, '').strip.gsub(/[\s\.:;=+~]+/, '_')
    end
    self.handle.downcase
  end
  
  def set_layouts
    self.layout         = Layout.find_by_name(Radiant::Config['shop.category_layout']) if self.layout.nil?
    self.product_layout = Layout.find_by_name(Radiant::Config['shop.product_layout']) if self.product_layout.nil?
  end
  
end
