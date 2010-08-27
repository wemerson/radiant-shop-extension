class ShopProductsDataset < Dataset::Base  

  uses :shop_categories, :images

  def load
    
    categories = {
      :bread => [ :soft, :crusty, :warm ],
      :milk => [ :full, :hilo, :choc ]
    }
    
    categories.each do |category, products|
      products.each_with_index do |product, i|
        create_record :shop_product, "#{product.to_s}_#{category.to_s}".to_sym,
          :name     => "#{product.to_s} #{category.to_s}",
          :sku      => "#{product.to_s}_#{category.to_s}",
          :price    => i + 1 * 10,
          :position => i + 1,
          :weight   => i + 10 * 3,
          :category => shop_categories(category)
      end
    end
    
    shop_products(:soft_bread).images = [
      images(:soft_bread_front),
      images(:soft_bread_back),
      images(:soft_bread_top)
    ]
    
    shop_products(:crusty_bread).images << images(:crusty_bread_front)
    
    shop_products(:warm_bread).images << images(:warm_bread_front)
    
  end
end
