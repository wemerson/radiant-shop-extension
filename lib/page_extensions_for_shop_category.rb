module PageExtensionsForShop
  class << self
    def included(base)
      base.belongs_to :shop_category, :class_name => 'ShopCategory', :foreign_key => 'shop_category_id'
    end
  end
end