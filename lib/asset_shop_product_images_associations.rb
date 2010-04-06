module AssetShopProductImagesAssociations
  
  def self.included(base)
    base.class_eval {
      has_many :shop_product_assets, :class_name => 'ShopProductAsset', :order => "position ASC", :dependent => :destroy
    }
  end
  
end