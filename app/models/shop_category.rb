class ShopCategory < ActiveRecord::Base
  has_many :products, :class_name => 'ShopProduct', :foreign_key => :category_id, :dependent => :destroy
  has_many :children, :class_name => 'ShopCategory', :foreign_key => :parent_id, :order => 'position', :dependent => :destroy

  belongs_to :parent, :class_name => 'ShopCategory'
  
  acts_as_list  :scope => :parent_id
  
  validates_presence_of :title
  validates_presence_of :handle
  
  validates_uniqueness_of :title
  validates_uniqueness_of :handle


  def to_s
    o=[]
    o << self.parent.to_s unless self.parent.nil?
    o << self.title
    o.join(' > ')
  end

  def to_param
    self.handle
  end

  def url
    "/category/#{to_param}"
  end

  def layout
    if !custom_layout.blank? then
      custom_layout
    else
      if self.parent_id.nil? then
        Radiant::Config['shop.products.category_layout'] || 'Category'
      else
        self.parent.layout
      end
    end
  end

  def product_layout
    if !custom_product_layout.blank? then
      custom_product_layout
    else
      if self.parent_id.nil? then
        Radiant::Config['shop.products.product_layout'] || 'Product'
      else
        self.parent.product_layout
      end
    end
  end

  def custom=(values)
    values.each do |key, value|
      self.json_field_set(key, value)
    end
  end

  def self.find_all_except(c, options={})
    options[:order] ||= 'sequence ASC'
    options[:conditions]=[ 'id != ?', c.id ] unless (c.blank? || c.new_record? )
    self.find(:all, options)
  end

  def self.find_all_top_level(options={})
    options[:order] ||= 'position ASC'
    if options[:conditions]
      options[:conditions]=[options[:conditions]] if !options[:conditions].is_a?(Array)
      options[:conditions][0]="(#{options[:conditions][0]}) AND parent_id IS NULL"
    else
      options[:conditions]="parent_id IS NULL"
    end
    self.find(:all, options)
  end
  
  class << self
    def search(search, filter, page)
      unless search.blank?

        search_cond_sql = []
        search_cond_sql << 'LOWER(title) LIKE (:term)'
        search_cond_sql << 'LOWER(description) LIKE (:term)'
        cond_sql = search_cond_sql.join(" OR ")

        @conditions = [cond_sql, {:term => "%#{search.downcase}%" }]
      else
        @conditions = []
      end

      options = { :conditions => @conditions,
                  :order => 'created_at DESC',
                  :page => page,
                  :per_page => 10 }

      ShopCategory.paginate(:all, options)
    end
  end

end