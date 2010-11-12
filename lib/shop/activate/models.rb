module Shop
  module Activate
    module Tags
      Page.send :include,  Shop::Models::Page
      Image.send :include, Shop::Models::Image
      User.send :include,  Shop::Models::User    
    end
  end
end