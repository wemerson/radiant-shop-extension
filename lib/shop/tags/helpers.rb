module Shop
  module Tags
    class Helpers
      class << self
        include ActionView::Helpers::NumberHelper
        
        def current_categories(tag)
          result = []
          
          # Returns the current categories if they exist
          if tag.locals.shop_categories.present?
            result = tag.locals.shop_categories
            
          # Returns categories based on the slug of their categories parent page
          elsif tag.attr['parent']
            result = ShopCategory.all(
                       :joins      => 'JOIN pages AS page ON page.id = shop_categories.page_id JOIN pages AS parent ON page.parent_id = parent.id',
                       :conditions => [ 'parent.slug = ?', tag.attr['parent'] ]
                     )
                  
          # Page params are protected, send is used to overcome this  
          # elsif tag.locals.page.send(:params).has_key? 'query'
          #   result = ShopCategory.search(tag.locals.page.send(:params)['query'])
           
          # Returns all Categories
          else
            result = ShopCategory.all
            
          end
          
          result
        end
        
        def current_category(tag)
          result = nil
          
          # Returns the current shop_category    
          if tag.locals.shop_category.present?
            result = tag.locals.shop_category
           
          # Returns a category based on its name (page title)  
          elsif tag.attr['name']
            result = ShopCategory.first(
                       :joins      => :page,
                       :conditions => [ "pages.title = ?", tag.attr['name'] ]
                     )
            
          # Returns a category based on its handle (page slug)
          elsif tag.attr['handle']
            result = ShopCategory.first(
                       :joins      => :page,
                       :conditions => [ "pages.slug = ?", tag.attr['handle'] ]
                     )
           
          # Returns the category of the current shop_product
          elsif tag.locals.shop_product.present?
             result = tag.locals.shop_product.category
                     
          elsif tag.locals.page.shop_category.present?
            result = tag.locals.page.shop_category
            
          elsif tag.locals.page.shop_product.present?
            result = tag.locals.page.shop_product.category
            
          end
          
          result
        end
        
        def current_products(tag)
          result = nil
          
          if tag.locals.shop_products.present?
            result = tag.locals.shop_products
          
          elsif tag.attr['category']
            result = ShopCategory.first(
                       :joins      => :page,
                       :conditions => [ 'page.slug = ?', tag.attr['category'] ]
                     ).products
            
          elsif tag.locals.shop_category.present?
            result = tag.locals.shop_category.products
        
          elsif tag.locals.page.shop_category.present?
            result = tag.locals.page.shop_category.products
            
          else
            result = ShopProduct.all
            
          end
          
          result
        end
        
        def current_product(tag)
          result = nil
          
          if tag.locals.shop_product.present?
            result = tag.locals.shop_product
          
          # Returns a product based on its name (page title)  
          elsif tag.attr['name']
            result = ShopProduct.first(
                       :joins      => :page,
                       :conditions => [ "pages.title = ?", tag.attr['name'] ]
                     )

          # Returns a product based on its sku (page slug)
          elsif tag.attr['sku']
            result = ShopProduct.first(
                       :joins      => :page,
                       :conditions => [ "pages.slug = ?", tag.attr['sku'] ]
                     )
          
          elsif tag.locals.shop_line_item.present? and tag.locals.shop_line_item.item_type === 'ShopProduct'
            result = tag.locals.shop_line_item.item

          elsif tag.locals.page.shop_product.present?
            result = tag.locals.page.shop_product
            
          end
          
          result
        end
        
        def current_order(tag)
          result = nil
          
          if tag.locals.shop_order.present?
            result  = tag.locals.shop_order
            
          elsif tag.attr['key'] and tag.attr['value']
            result  = ShopOrder.first(:conditions => { tag.attr['key'].downcase.to_sym => tag.attr['value'] })
            
          elsif tag.locals.page.request.session[:shop_order].present?
            session = tag.locals.page.request.session[:shop_order]
            result  = ShopOrder.find(session)
          
          elsif tag.locals.response.present? and tag.locals.response.result[:checkout].present?
            result  = ShopOrder.find(tag.locals.response.result[:checkout][:order])
          
          end
          
          result
        end
        
        def current_line_items(tag)
          result = nil
          
          if tag.locals.shop_line_items.present?
            result = tag.locals.shop_line_items
          else
            result = tag.locals.shop_order.line_items
          end
          
          result
        end

        def current_line_item(tag)
          result = nil
          
          if tag.locals.shop_line_item.present?
            result  = tag.locals.shop_line_item
            
          elsif tag.locals.shop_order.present? and tag.locals.shop_product.present?
            result  = tag.locals.shop_order.line_items.find_by_item_id(tag.locals.shop_product.id)
            
          end
          
          result
        end
        
        # Return the current address for the current order
        # @tag['attr]['type'] = the address type (billing|shippin)
        def current_address(tag)
          result = nil
          
          if tag.locals.address.present? and tag.locals.address_type == tag.attr['type']
            result = tag.locals.address
            
          elsif tag.locals.shop_order.present?
            begin
              address = tag.locals.shop_order.send(tag.attr['type']) # Get the address type (order.billing)
              if address.present? # If that address exists
                result = address # The result is that address
              end
            rescue
              result = nil # Will catch an incorrect address type being send
            end
            
          end
          
          result
        end
        
        def current_packages(tag)
          result = nil
          
          if tag.locals.shop_product.present?
            result = tag.locals.shop_product.packages
          
          elsif tag.attr['key'] and tag.attr['value']
            result = ShopPackage.all(:conditions => { tag.attr['key'].downcase.to_sym => tag.attr['value']})
            
          else
            result = ShopPackage.all
            
          end
          
          result
        end
        
        def current_package(tag)
          result = nil
          
          if tag.locals.shop_package.present?
            result = tag.locals.shop_package
            
          elsif tag.attr['key'] and tag.attr['value']
            result = ShopPackage.first(:conditions => { tag.attr['key'].downcase.to_sym => tag.attr['value']})
          
          end
          
          result
        end
        
        def current_product_variants(tag)
          result = nil
          
          if tag.locals.shop_product.present?
            result = tag.locals.shop_product.variants
          end
          
          result
        end
        
        def current_product_variant(tag)
          result = nil
          
          if tag.locals.shop_product_variant.present?
            result = tag.locals.shop_product_variant
          end
          
          result
        end
        
        def currency(number,attr = {})
          number_to_currency(number.to_f, 
            :precision  =>(attr[:precision] || Radiant::Config['shop.price_precision']).to_i,
            :unit       => attr[:unit]      || Radiant::Config['shop.price_unit'],
            :separator  => attr[:separator] || Radiant::Config['shop.price_separator'],
            :delimiter  => attr[:delimiter] || Radiant::Config['shop.price_delimiter'])
        end
        
      end
    end
  end
end