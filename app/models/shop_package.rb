class ShopPackage < ActiveRecord::Base
  
  belongs_to  :created_by,  :class_name => 'User'
  belongs_to  :updated_by,  :class_name => 'User'
  
  has_many    :packings, :class_name => 'ShopPacking', :dependent => :destroy
  has_many    :products, :class_name => 'ShopProduct', :through => :packings
  
  has_many    :line_items,  :class_name => 'ShopLineItem', :as => :item
  has_many    :orders,      :class_name => 'ShopOrder', :through => :line_items
  
  before_validation         :set_sku, :filter_sku
  
  validates_presence_of     :name, :sku
  
  validates_uniqueness_of   :name, :sku
  
  validates_numericality_of :price, :greater_than => 0.00, :allow_nil => true, :precisions => 2
  
  def value
    value = 0
    self.packings.map { |pkg| value += (pkg.product.price.to_f * pkg.quantity) }
    value
  end
  
  def weight
    weight = 0
    self.packings.map { |pkg| weight += (pkg.product.weight.to_f * pkg.quantity) }
    weight
  end
  
  def available_products
    ShopProduct.find(:all, :joins => :category, :order => 'shop_categories.position, shop_products.position ASC') - self.products
  end
  
  def slug
    products.first.slug
  end
  
  class << self
    
    def attrs
      [ :id, :name, :price, :sku, :description, :created_at, :updated_at ]
    end
    
    def params
      {
        :include  => { 
          :category => { :only => ShopCategory.attrs },
          :products => { :only => ShopProduct.attrs }
        },
        :only     => ShopPackage.attrs
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