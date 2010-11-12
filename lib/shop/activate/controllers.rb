module Shop
  module Activate
    module Tags
    
      def self.included(base)
        base.class_eval do
          ApplicationController.send :include, Shop::Controllers::ApplicationController
          SiteController.send :include, Shop::Controllers::SiteController
        end
      end
    
    end
  end
end