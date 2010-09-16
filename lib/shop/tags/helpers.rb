module Shop
  module Tags
    class Helpers
      class << self
        
        def current_categories(tag)
          result = []
          
          # Page params are protected, send is used to overcome this
          if tag.locals.shop_categories.present?
            result = tag.locals.shop_categories
          elsif tag.locals.page.send(:params).has_key? 'query'
            result = ShopCategory.search(tag.locals.page.params['query'])
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
          elsif tag.attr['key'] and tag.attr['value']
            result = ShopCategory.first(:conditions => { tag.attr['key'].downcase.to_sym => tag.attr['value'] })
          elsif tag.locals.page.shop_category.present?
            result = tag.locals.page.shop_category
          elsif tag.locals.page.shop_product.present?
            result = tag.locals.page.shop_product.category
          elsif tag.locals.shop_product.present?
            result = tag.locals.shop_product.category
          else
            result = ShopCategory.find_by_handle(tag.locals.page.slug)
          end
          
          result
        end
        
        def current_products(tag)
          result = nil
         
          if tag.locals.shop_products.present?
            result = tag.locals.shop_products
          elsif tag.locals.page.send(:params).has_key? 'query'
            result = ShopProduct.search(tag.locals.page.params['query'])
          elsif tag.attr['key'] and tag.attr['value']
            result = ShopProduct.all(:conditions => { tag.attr['key'].downcase.to_sym => tag.attr['value'] })
          elsif tag.locals.page.shop_category.present?
            result = tag.locals.page.shop_category.products          
          elsif tag.locals.shop_category.present?
            result = tag.locals.shop_category.products  
          else
            result = ShopProduct.all
          end
          
          result
        end
        
        def current_product(tag)
          
          result = nil

          if tag.locals.shop_product.present?
            result = tag.locals.shop_product
          elsif tag.locals.page.shop_product.present?
            result = tag.locals.page.shop_product
          elsif tag.attr['key'] and tag.attr['value']
            result = ShopProduct.first(:conditions => { tag.attr['key'].downcase.to_sym => tag.attr['value'] })
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