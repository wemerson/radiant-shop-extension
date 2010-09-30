module Shop
  module Interface
    module Products
      
      def self.included(base)
        base.send :include, InstanceMethods
      end
      
      module InstanceMethods
        attr_accessor :products, :categories
        
        protected
          def load_default_shop_products_regions
            returning OpenStruct.new do |products|
              products.edit = Radiant::AdminUI::RegionSet.new do |edit|
                edit.main.concat %w{head form popups}
                edit.form.concat %w{inputs meta parts foot}
                edit.foot.concat %w{buttons timestamp}
              end
              products.new = products.edit
              products.index = Radiant::AdminUI::RegionSet.new do |index|
                index.head.concat     %w{name modify}
                index.category.concat %w{move name handle modify}
                index.products.concat %w{body}
                index.product.concat  %w{move icon name sku modify}
                index.foot.concat     %w{add}
              end
              products.remove = products.index
            end
          end
          
          def load_default_shop_categories_regions
            returning OpenStruct.new do |categories|
              categories.edit = Radiant::AdminUI::RegionSet.new do |edit|
                edit.main.concat %w{head form popups}
                edit.form.concat %w{inputs meta parts foot}
                edit.foot.concat %w{buttons timestamp}
              end
              categories.new = categories.edit
              categories.remove = categories.index
            end          
          end
      end
      
    end
  end
end