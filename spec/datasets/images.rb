class ImagesDataset < Dataset::Base
  def load
    images = [ :soft_bread_front, :soft_bread_back, :soft_bread_top, :crusty_bread_front, :warm_bread_front ]
    
    images.each_with_index do |image, i|
      create_record :image, image, 
        :title              => image.to_s,
        :asset_file_name    => "#{image.to_s}_file_name.png",
        :asset_content_type => "image/png",
        :asset_file_size    => i+1*1000
    end
  end
end