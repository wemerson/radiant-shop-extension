module Shop
  module Tags
    class Helpers
      class << self
        
        def current_categories(tag)
          result = []
          
          # Page params are protected, send is used to overcome this
          if tag.locals.page.send(:params).has_key? 'query'
            result = ShopCategory.search(tag.locals.page.params['query'])
          else
            result = ShopCategory.all
          end
          
          result
        end
        
        def current_category(tag)
          result = nil
          
          if tag.attr['id']
            result = ShopCategory.find(tag.attr['id'])
          elsif tag.attr['handle']
            result = ShopCategory.find_by_handle(tag.attr['handle'])
          elsif tag.attr['name']
            result = ShopCategory.find_by_name(tag.attr['name'])
          elsif tag.attr['position']
            result = ShopCategory.find_by_position(tag.attr['position'])
          elsif !tag.locals.page.shop_category.nil?
            result = tag.locals.page.shop_category
          elsif !tag.locals.page.shop_product.nil?
            result = tag.locals.page.shop_product.category            
          elsif !tag.locals.shop_category.nil?
            result = tag.locals.shop_category
          elsif !tag.locals.shop_product.nil?
            result = tag.locals.shop_product.category
          else
            result = ShopCategory.find_by_handle(tag.locals.page.slug)
          end
          
          result
        end
        
        def current_products(tag)
          result = nil

          

          if tag.locals.page.send(:params).has_key? 'query'
            result = ShopProduct.search(tag.locals.page.params['query'])
          elsif !tag.locals.page.shop_category.nil?
            result = tag.locals.page.shop_category.products          
          elsif !tag.locals.shop_category.nil?
            result = tag.locals.shop_category.products  
          else
            result = ShopProduct.all
          end
          
          result
        end
        
        def current_product(tag)
          
          result = nil

          if tag.attr['id']
            result = ShopProduct.find(tag.attr['id'])
          elsif tag.attr['sku']
            result = ShopProduct.find_by_sku(tag.attr['sku'])
          elsif tag.attr['name']
            result = ShopProduct.find_by_name(tag.attr['name'])
          elsif tag.attr['position']
            result = ShopProduct.find_by_position(tag.attr['position'])
          elsif !tag.locals.page.shop_product.nil?
            result = tag.locals.page.shop_product
          elsif !tag.locals.shop_product.nil?
            result = tag.locals.shop_product
          else
            result = ShopProduct.find_by_sku(tag.locals.page.slug)
          end
          
          result
        end
        
        def current_order(tag)
          result = nil
          
          if !tag.locals.shop_order.nil?
            result  = tag.locals.shop_order
          elsif tag.attr['id']
            result  = ShopOrder.find(tag.attr['id'])
          elsif tag.locals.page.request.session[:shop_order]
            begin
              result  = ShopOrder.find(tag.locals.page.request.session[:shop_order])
            rescue
              result  = ShopOrder.create
              tag.locals.page.request.session[:shop_order] = result.id
            end
          end
          
          result
        end

        def current_line_item(tag)
          result = nil
          
          if !tag.locals.shop_line_item.nil?
            result  = tag.locals.shop_line_item
          elsif !tag.locals.shop_product.nil?
            order   = tag.locals.shop_order
            product = tag.locals.shop_product
            item    = order.line_items.find_by_item_id(product.id)
            
            result  = item
          end
          
          result
        end
        
      end
    end
  end
end