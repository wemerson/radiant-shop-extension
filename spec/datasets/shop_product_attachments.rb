class ShopProductAttachmentsDataset < Dataset::Base
  
  uses :shop_products
  
  def load
    images = [ :soft_bread_front, :soft_bread_back, :soft_bread_top, :crusty_bread_front, :warm_bread_front ]
    
    images.each_with_index do |image, i|
      create_record :image, image, 
        :title              => image.to_s,
        :asset_file_name    => "#{image.to_s}_file_name.png",
        :asset_content_type => "image/png",
        :asset_file_size    => i+1*1000
        
      create_record :shop_product_attachment, image,
        :image    => images(image.to_sym),
        :product  => shop_products(image.to_s.split('_')[0,2].join('_').to_sym),
        :position => i + 1
    end
  end
end