module Shop
  module Activate
    module Tags
      
      ApplicationController.send :include, Shop::Controllers::ApplicationController
      SiteController.send :include, Shop::Controllers::SiteController
      
    end
  end
end