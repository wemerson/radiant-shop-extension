module Shop
  module Tags
    class Helpers
      class << self
        
        def current_categories(tag)
          result = []
          
          if tag.locals.shop_categories.present?
            result = tag.locals.shop_categories
          
            # Page params are protected, send is used to overcome this  
          elsif tag.locals.page.send(:params).has_key? 'query'
            result = ShopCategory.search(tag.locals.page.send(:params)['query'])
            
          elsif tag.attr['key'] and tag.attr['value']
            result = ShopCategory.all(:conditions => { tag.attr['key'].downcase.to_sym => tag.attr['value'] })
            
          else
            result = ShopCategory.all
            
          end
          
          result
        end
        
        def current_category(tag)
          result = nil
          
          if tag.locals.shop_category.present?
            result = tag.locals.shop_category
            
          elsif tag.locals.shop_product.present?
            result = tag.locals.shop_product.category
            
          elsif tag.attr['key'] and tag.attr['value']
            result = ShopCategory.first(:conditions => { tag.attr['key'].downcase.to_sym => tag.attr['value'] })
            
          elsif tag.locals.page.shop_category.present?
            result = tag.locals.page.shop_category
            
          elsif tag.locals.page.shop_product.present?
            result = tag.locals.page.shop_product.category
            
          else
            result = ShopCategory.find_by_handle(tag.locals.page.slug)
            
          end
          
          result
        end
        
        def current_products(tag)
          result = nil
         
          if tag.locals.shop_products.present?
            result = tag.locals.shop_products
            
          elsif tag.locals.shop_category.present?
            result = tag.locals.shop_category.products
                        
          elsif tag.locals.page.send(:params).has_key? 'query'
            result = ShopProduct.search(tag.locals.page.params['query'])
            
          elsif tag.attr['key'] and tag.attr['value']
            result = ShopProduct.all(:conditions => { tag.attr['key'].downcase.to_sym => tag.attr['value'] })
            
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
            
          elsif tag.attr['key'] and tag.attr['value']
            result = ShopProduct.first(:conditions => { tag.attr['key'].downcase.to_sym => tag.attr['value'] })
            
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
        
      end
    end
  end
end