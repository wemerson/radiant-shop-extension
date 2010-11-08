class ShopCategory < ActiveRecord::Base
  
  default_scope :joins => 'JOIN pages AS page ON page.id = shop_categories.page_id JOIN pages AS parent ON page.parent_id = parent.id',
    :order => 'parent.position, page.position ASC'
  
  belongs_to  :page,            :dependent => :destroy
  belongs_to  :created_by,      :class_name => 'User'
  belongs_to  :updated_by,      :class_name => 'User'
  belongs_to  :product_layout,  :class_name => 'Layout'
  
  before_validation             :assign_slug, :assign_breadcrumb, :assign_page_class_name
  
  accepts_nested_attributes_for :page
  
  validates_presence_of         :page
  
  # Returns the title of the product's page
  def name; page.title; end
  
  # Returns the url of the page formatted as an sku
  def handle; ShopProduct.to_sku(page.url); end
  
  # Returns the content of the product's page's description part
  def description
    begin
      page.parts.find_by_name('description').content
    rescue 
      ''
    end
  end
  
  # Returns products through the pages children
  def products; page.children.all(:conditions => { :class_name => 'ShopProductPage' }).map(&:shop_product); end
  
  # Returns the url of the page
  def url; page.url;  end
  
  # Returns the page slug
  def slug; page.slug; end
  
  # Overloads the base to_json to return what we want
  def to_json(*attrs); super self.class.params; end
  
  class << self
    
    # Sorts a group of categories based on their ID and position in an array
    def sort(category_ids)
      category_ids.each_with_index do |id, index|
        ShopCategory.find(id).page.update_attributes!(
          :position  => index+1
        )
      end
    end
    
    # Returns attributes attached to the category
    def attrs
      [ :id, :product_layout_id, :page_id, :created_at, :updated_at ]
    end
    
    # Returns methods with usefuly information
    def methds
      [ :name, :description, :handle, :url, :created_at, :updated_at ]
    end
    
    # Returns a custom hash of attributes on the category
    def params
      { :only => self.attrs, :methods => self.methds }
    end
    
  end
  
  protected
  
  # Assigns a slug to a page if its not set
  def assign_slug
    if page.present?
      self.page.slug = ShopProduct.to_sku(page.slug.present? ? page.slug : page.title)
    end
  end
  
  # Assigns a breadcrumb to the page if its not set
  def assign_breadcrumb
    if page.present?
      self.page.breadcrumb = ShopProduct.to_sku(page.breadcrumb.present? ? page.breadcrumb : page.slug)
    end
  end

  # Assigns a page class if its nil
  def assign_page_class_name
    if page.present?
      self.page.class_name = page.class_name || 'ShopCategoryPage'
    end
  end
  
end
