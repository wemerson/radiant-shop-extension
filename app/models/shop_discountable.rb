class ShopDiscountable < ActiveRecord::Base
  
  belongs_to :discount,   :class_name => 'ShopDiscount',   :foreign_key => :discount_id
  belongs_to :discounted, :foreign_key => :discounted_id,  :polymorphic => true
  belongs_to :category,   :class_name => 'ShopCategory',   :foreign_key => :discounted_id
  belongs_to :product,    :class_name => 'ShopProduct',    :foreign_key => :discounted_id
  
  validates_presence_of   :discount, :discounted
  validates_uniqueness_of :discounted_id, :scope => [ :discount_id, :discounted_type ]
  
  after_create              :create_shop_products_if_shop_category
  before_destroy            :destroy_shop_products_if_shop_category
  
  protected
  
  # Adds discount to a category and its products
  def create_shop_products_if_shop_category
    if discounted_type === 'ShopCategory'
      discounted.products.each do |product|
        # Attach discount to the child product
        ShopDiscountable.create(:discount => discount, :discounted => product)
      end
    end
  end
  
  # Adds discount from a category and its products
  def destroy_shop_products_if_shop_category
    if discounted_type === 'ShopCategory'
      discounted.products.each do |product|
        discountable = discount.discountables.first(:conditions => { :discounted_id => product.id, :discounted_type => product.class.name })
        
        # Remove discount of the child product
        discountable.destroy
      end
    end
  end
  
end