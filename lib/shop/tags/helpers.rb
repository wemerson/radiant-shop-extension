module Shop
  module Tags
    class Helpers
      class << self
        
        def current_categories(tag)
          result = []
          
          if tag.locals.page.params.has_key? 'query'
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
          elsif defined?(tag.locals.shop_category)
            result = tag.locals.shop_category
          elsif defined?(tag.locals.page.shop_category_id)
            result = ShopCategory.find(tag.locals.page.shop_category_id)
          elsif defined?(tag.locals.shop_product)
            result = tag.locals.shop_product.category     
          else
            result = ShopCategory.find_by_handle(tag.locals.page.slug)
          end
          
          result
        end
        
        def current_products(tag)
          result = nil

          if tag.locals.page.params.has_key? 'query'
            result = ShopProduct.search(tag.locals.page.params['query'])
          elsif defined?(tag.locals.shop_category)
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
          elsif defined?(tag.locals.shop_product)
            result = tag.locals.shop_product
          else
            result = ShopProduct.find_by_sku(tag.locals.page.slug)
          end
          
          result
        end
        
        def current_order(tag)
          if tag.locals.shop_order
            tag.locals.shop_order
          elsif tag.attr['id']
            ShopOrder.find(tag.attr['id'])
          elsif tag.locals.page.request.session[:shop_order]
            ShopOrder.find(tag.locals.page.request.session[:shop_order])
          end
        end

        def current_line_item(tag)
          if tag.locals.shop_line_item
            tag.locals.shop_line_item
          elsif tag.attr['product_id']
            tag.locals.shop_line_item = tag.local.shop_order.line_items.find_by_shop_product_id(tag.attr['product_id'])
          end
        end
        
      end
    end
  end
end