module Shop
  module Models
    module Image
      
      def self.included(base)
        base.class_eval do
          has_many :shop_product_attachments, :dependent => :destroy
          has_many :shop_products,            :through => :shop_product_attachments, :source => :product
        end
      end
      
    end
  end
end