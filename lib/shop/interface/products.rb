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
                edit.main.concat %w{edit_header edit_form edit_popups}
                edit.form.concat %w{edit_name edit_price edit_extended_metadata edit_content}
                edit.form_bottom.concat %w{edit_buttons edit_timestamp}
              end
              products.new = products.edit
              products.index = Radiant::AdminUI::RegionSet.new do |index|
                index.bottom.concat %w{ add_category }
                index.thead.concat %w{ name_header description_header modify_header }
                index.category_attributes.concat %w{ category_name category_description category_modify }
                index.category_products.concat %w{ category_products }
                index.product.concat %w{ product_name product_modify }
              end
              products.remove = products.index
            end
          end
          
          def load_default_shop_categories_regions
            returning OpenStruct.new do |categories|
              categories.edit = Radiant::AdminUI::RegionSet.new do |edit|
                edit.main.concat %w{edit_header edit_form edit_popups}
                edit.form.concat %w{edit_name edit_extended_metadata edit_content}
                edit.form_bottom.concat %w{edit_buttons edit_timestamp}
              end
              categories.new = categories.edit
              categories.remove = categories.index
            end          
          end
      end
      
    end
  end
end