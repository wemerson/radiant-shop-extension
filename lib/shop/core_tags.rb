module Shop
  module CoreTags
    include Radiant::Taggable
          
    tag 'shop' do |tag|
      tag.expand
    end
  
  end
end