module Shop
  module Models
    module Page
    
      def self.included(base)
        base.class_eval do
          belongs_to :shop_category,  :class_name => 'ShopCategory',  :foreign_key => 'shop_category_id'
          belongs_to :shop_product,   :class_name => 'ShopProduct',   :foreign_key => 'shop_product_id'
        end
      end
      
    end
  end
end