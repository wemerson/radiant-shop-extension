class ShopProductsDataset < Dataset::Base  

  uses :shop_categories

  def load
    categories = {
      :bread => [ :soft, :crusty, :warm ],
      :milk => [ :full, :hilo, :choc ]
    }
    
    categories.each do |category, products|
      products.each_with_index do |product, i|
        create_record :page, product,
          :title      => "#{product.to_s} #{category.to_s}",
          :slug       => "#{product.to_s}_#{category.to_s}",
          :parent     => shop_categories(category).page,
          :class_name => 'ShopProductPage',
          :layout     => layouts(:product)

        create_record :shop_product, "#{product.to_s}_#{category.to_s}".to_sym,
          :price      => i + 1 * 10,
          :page       => pages(product).id

        create_record :page_part, product,
          :name       => 'description',
          :content    => "*#{category.to_s}*",
          :page       => pages(product)
      end
    end
  end
  
end
