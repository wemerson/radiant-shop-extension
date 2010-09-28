module Shop
  module Interface
    module Customers
      
      def self.included(base)
        base.send :include, InstanceMethods
      end
      
      module InstanceMethods
        attr_accessor :customers
        
        protected
          def load_default_shop_customers_regions
            returning OpenStruct.new do |customers|
              customers.edit = Radiant::AdminUI::RegionSet.new do |edit|
                edit.main.concat %w{header form popups}
                edit.form.concat %w{name email meta parts}
                edit.bottom.concat %w{buttons timestamp}
              end
              customers.new = customers.edit
              customers.index = Radiant::AdminUI::RegionSet.new do |index|
                index.top
                index.bottom.concat %w{ add }
                index.thead.concat %w{ name modify }
                index.customer.concat %w{ name modify }
              end
              customers.remove = customers.index
            end
          end
      end
      
    end
  end
end