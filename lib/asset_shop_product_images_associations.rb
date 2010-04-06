module AssetShopProductImagesAssociations
  
  def self.included(base)
    base.class_eval {
      has_many :shop_product_images, :class_name => 'ShopProductImage', :order => "position ASC", :dependent => :destroy
    }
  end
  
end