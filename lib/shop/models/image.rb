module Shop
  module Models
    module Image
      
      def self.included(base)
        base.class_eval do
          has_many :shop_product_images, :class_name => 'ShopProductImage', :order => "position ASC", :dependent => :destroy
        end
      end
      
    end
  end
end