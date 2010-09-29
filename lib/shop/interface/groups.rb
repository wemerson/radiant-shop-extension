module Shop
  module Interface
    module Groups
      
      def self.included(base)
        base.send :include, InstanceMethods
      end
      
      module InstanceMethods
        attr_accessor :groups
        
        protected
          def load_default_shop_groups_regions
            returning OpenStruct.new do |groups|
              groups.edit = Radiant::AdminUI::RegionSet.new do |edit|
                edit.head.concat %w{title form popups}
                edit.body.concat %w{inputs meta parts}
                edit.foot.concat %w{buttons timestamp}
              end
              groups.new = groups.edit
              groups.index = Radiant::AdminUI::RegionSet.new do |index|
                index.head.concat %w{name modify}
                index.body.concat %w{name modify}
                index.foot.concat %w{add}
              end
              groups.remove = groups.index
            end
          end
      end
      
    end
  end
end