class ShopProduct < ActiveRecord::Base
  belongs_to :category, :class_name => 'ShopCategory'
  acts_as_list :scope => :category

  has_many :line_items, :class_name => 'ShopLineItem', :foreign_key => 'product_id'
  has_many :product_attachments, :class_name => 'ShopProductAttachment', :foreign_key => 'product_id'
  has_many :images, :through => :product_attachments, :order => 'shop_product_attachments.position ASC', :uniq => :true
  
  validates_presence_of :title
  validates_uniqueness_of :title 
  validates_presence_of :sku
  validates_uniqueness_of :sku
  validates_presence_of :handle
  validates_uniqueness_of :handle
  validates_numericality_of :price, :greater_than => 0.00, :allow_nil => true

  def to_param
    self.title.downcase.gsub(/[^A-Za-z\-]/,'_').gsub(/-+/,'_')
  end
  
  def url
    "product/#{self.to_param}"
  end

  def layout
    self.category.product_layout
  end

  def custom=(values)
    values.each do |key, value|
      self.json_field_set(key, value)
    end
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
                  :order => 'position DESC',
                  :page => page,
                  :per_page => 10 }

      ShopProduct.paginate(:all, options)
    end
  end

end
