module ShopTags
  include Radiant::Taggable
  include ERB::Util
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::UrlHelper
  
  tag 'shop' do |tag|
    tag.expand
  end
  
end
