class ShopDiscount < ActiveRecord::Base
  
  belongs_to  :created_by,  :class_name => 'User'
  belongs_to  :updated_by,  :class_name => 'User'
  
  has_many    :discountables, :class_name => 'ShopDiscountable', :foreign_key  => :discount_id
  has_many    :categories,    :through => :discountables, :source => :category, :conditions => "shop_discountables.discounted_type = 'ShopCategory'"
  has_many    :products,      :through => :discountables, :source => :product,  :conditions => "shop_discountables.discounted_type = 'ShopProduct'"
  
  validates_presence_of     :name, :code, :amount
  validates_uniqueness_of   :name, :code
  validates_numericality_of :amount
  
  # Return all categories minus its own
  def available_categories
    ShopCategory.all - categories
  end
  
  # Returns all products minus its own
  def available_products
    ShopProduct.all - products
  end
  
  # Adds discount to a category and its products
  def add_category(category)
    discountables.create(:discounted => category) # Attach discount to itself
    
    category.products.each do |product|
      ShopDiscountable.create(:discount => self, :discounted => product) # Attach discount to the child product
    end
  end
  
  # Adds discount from a category and its products
  def remove_category(category)
    discount = discountables.first(:conditions => { :discounted_id => category.id, :discounted_type => category.class.name })
    discount.destroy # Remove discount of category
    
    category.products.each do |product|
      discount = discountables.first(:conditions => { :discounted_id => product.id, :discounted_type => product.class.name })
      
      discount.destroy # Remove discount of the child product
    end    
  end
  
end