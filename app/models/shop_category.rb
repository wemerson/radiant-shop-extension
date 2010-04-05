class ShopCategory < ActiveRecord::Base
  has_many :products, :class_name => 'ShopProduct', :foreign_key => :category_id, :dependent => :destroy
  has_many :children, :class_name => 'ShopCategory', :foreign_key => :parent_id, :order => 'position', :dependent => :destroy
  
  belongs_to :parent, :class_name => 'ShopCategory'
  
  acts_as_list  :scope => :parent_id
  
  validates_presence_of :title
  validates_presence_of :handle
  
  validates_uniqueness_of :title
  validates_uniqueness_of :handle
  
  before_validation :set_handle
  before_validation :filter_handle
  
  def custom=(values)
    values.each do |key, value|
      self.json_field_set(key, value)
    end
  end
  
  class << self
    def search(search)
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
                  :order => 'position DESC'
                }
      
      ShopCategory.find(:all, options)
    end
  end
  
private
  
  def filter_handle
    self.handle = self.handle.downcase.gsub(/[^-a-z0-9~\s\.:;+=_]/, '').strip.gsub(/[\s\.:;=+]+/, '-')
  end
  
  def set_handle
    self.handle = self.title if self.handle.nil? or self.handle.empty?
  end
  
end