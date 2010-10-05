class ShopProduct < ActiveRecord::Base
  
  default_scope             :joins => :category, :order => 'shop_categories.position, shop_products.position ASC'
    
  belongs_to  :created_by,  :class_name => 'User'
  belongs_to  :updated_by,  :class_name => 'User'
  belongs_to  :category,    :class_name => 'ShopCategory'
  
  has_many    :line_items,  :class_name => 'ShopLineItem',          :foreign_key  => :item_id,      :dependent => :destroy
  has_many    :orders,      :class_name => 'ShopOrder',             :through      => :line_items,   :uniq => true
  has_many    :attachments, :class_name => 'ShopProductAttachment', :foreign_key  => :product_id
  has_many    :images,      :class_name => 'Image',                 :through      => :attachments,  :uniq => true
  has_many    :packings,    :class_name => 'ShopPacking',           :foreign_key  => :product_id,   :dependent => :destroy
  has_many    :packages,    :class_name => 'ShopPackage',           :through      => :packings,     :source => :package
  has_many    :related,     :class_name => 'ShopProduct',           :through      => :packings,     :source => :item,       :uniq => true
  has_many    :variants,    :class_name => 'ShopProductVariant',    :foreign_key  => :product_id,   :dependent => :destroy
  
  before_validation         :set_sku, :filter_sku
  validates_presence_of     :name,    :sku,     :category
  validates_uniqueness_of   :name,    :scope => :category_id
  validates_uniqueness_of   :sku
  validates_numericality_of :price,   :greater_than => 0.00,    :allow_nil => true,     :precisions => 2
  
  accepts_nested_attributes_for :variants
  
  acts_as_list              :scope =>  :category
  
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
  
  def slug
    "/#{slug_prefix}/#{category.handle}/#{sku}"
  end
  
  def layout
    category.product_layout
  end
  
  def available_images
    Image.all - images
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
      
      all({ :conditions => conditions })
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
  
  class << self
    
    def to_sku_or_handle(name)
      name.downcase.gsub(/[^-a-z0-9~\s\.:;+=_]/, '').strip.gsub(/[\s\.:;=+~]+/, '_')
    end
    
  end
  
private
  
  def set_sku
    unless name.nil?
      self.sku = name if sku.nil? or sku.empty?
    end
  end
  
  def filter_sku
    unless name.nil?
      self.sku = ShopProduct.to_sku_or_handle(sku)
    end
  end
  
end
