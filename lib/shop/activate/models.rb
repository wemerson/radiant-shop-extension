module Shop
  module Activate
    module Tags
  
      def self.included(base)
        base.class_eval do
          Page.send :include,  Shop::Models::Page
          Image.send :include, Shop::Models::Image
          User.send :include,  Shop::Models::User
        end
      end
    
    end
  end
end