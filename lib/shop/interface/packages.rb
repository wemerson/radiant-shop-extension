module Shop
  module Interface
    module Packages
      
      def self.included(base)
        base.send :include, InstanceMethods
      end
      
      module InstanceMethods
        attr_accessor :packages
        
        protected
          def load_default_shop_packages_regions
            returning OpenStruct.new do |packages|
              packages.edit = Radiant::AdminUI::RegionSet.new do |edit|
                edit.main.concat %w{ head form popups }
                edit.sidebar
                edit.form.concat %w{ name price metadata content }
                edit.bottom.concat %w{ buttons timestamp }
              end
              packages.new = packages.edit
              packages.index = Radiant::AdminUI::RegionSet.new do |index|
                index.top
                index.bottom.concat %w{ create }
                index.thead.concat %w{ name modify }
                index.package.concat %w{ name modify }
              end
              packages.remove = packages.index
            end
          end
      end
      
    end
  end
end