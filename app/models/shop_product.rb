class ShopProduct < ActiveRecord::Base
  
  #default_scope :joins => :page, :order => 'pages.position ASC'
  
  belongs_to  :page,        :dependent  => :destroy 
  belongs_to  :created_by,  :class_name => 'User'
  belongs_to  :updated_by,  :class_name => 'User'
  
  has_many    :line_items,  :class_name => 'ShopLineItem',          :foreign_key  => :item_id,      :dependent => :destroy
  has_many    :orders,      :class_name => 'ShopOrder',             :through      => :line_items,   :uniq      => true
  has_many    :attachments, :class_name => 'ShopProductAttachment', :foreign_key  => :product_id
  has_many    :images,      :class_name => 'Image',                 :through      => :attachments,  :uniq      => true
  has_many    :packings,    :class_name => 'ShopPacking',           :foreign_key  => :product_id
  has_many    :packages,    :class_name => 'ShopPackage',           :foreign_key  => :package_id,   :through   => :packings, :source => :package
  has_many    :related,     :class_name => 'ShopProduct',           :through      => :packings,     :source    => :item,     :uniq => true
  has_many    :variants,    :class_name => 'ShopProductVariant',    :foreign_key  => :product_id,   :dependent => :destroy
  
  before_validation             :assign_slug, :assign_breadcrumb
  validates_presence_of         :page
  
  validates_numericality_of     :price,   :greater_than => 0.00,    :allow_nil => true,     :precisions => 2
  
  accepts_nested_attributes_for :page
  accepts_nested_attributes_for :variants
  
  def category
    page.parent.shop_category
  end
  
  def description
    page.parts.first.content
  end
  
  def name
    page.title rescue read_attribute(:name)
  end
  
  def sku
    page.slug rescue read_attribute(:sku)
  end
  
  def slug
    warn "[DEPRECATION] `slug` is deprecated.  Please use `url` instead."
    page.url
  end
  
  def url
    page.url
  end
  
  def apply_variant_template(variant)
    result = true
    variant.options.each do |variant|
      variants.new(:name => variant).save! rescue (result = false)
    end
    result
  end
  
  def customers
    line_items.map(&:customer).flatten.compact.uniq
  end
  
  def available_images
    Image.all - images
  end
  
  class << self
    
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
  
  class << self
    
    def to_sku_or_handle(name)
      name.downcase.gsub(/[^-a-z0-9~\s\.:;+=_]/, '').strip.gsub(/[\s\.:;=+~]+/, '_')
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
