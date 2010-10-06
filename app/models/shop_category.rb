class ShopCategory < ActiveRecord::Base
  
  default_scope :joins => :page, :order => 'pages.position ASC'
  
  belongs_to  :page,            :dependent => :destroy
  belongs_to  :created_by,      :class_name => 'User'
  belongs_to  :updated_by,      :class_name => 'User'
  belongs_to  :layout,          :class_name => 'Layout'
  belongs_to  :product_layout,  :class_name => 'Layout'
  belongs_to  :variant,         :class_name => 'ShopVariant'
  
  before_validation             :assign_slug, :assign_breadcrumb
  
  accepts_nested_attributes_for :page
  
  validates_presence_of         :page
  
  def products
    page.children.map(&:shop_product) rescue nil
  end
  
  def name
    page.title rescue read_attribute(:name)
  end
  
  def handle
    page.slug
  end
  
  def slug
    warn "[DEPRECATION] `slug` is deprecated.  Please use `url` instead."
    page.url
  end
  
  def url
    page.url
  end
  
  class << self
  
    def search(search)
      unless search.blank?
        queries = []
        #queries << 'LOWER(shop_categories.name)         LIKE (:term)'
        #queries << 'LOWER(shop_categories.handle)       LIKE (:term)'
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
  
  protected
  
  def assign_slug
    self.page.slug = ShopProduct.to_sku_or_handle(page.title) unless page.slug.present?
  end
  
  def assign_breadcrumb
    self.page.breadcrumb = page.slug
  end
  
end
