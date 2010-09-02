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
          
          if tag.locals.shop_category
            result = tag.locals.shop_category.products
          elsif tag.locals.page.params.include? 'handle'
            category = ShopCategory.find_by_handle(tag.locals.page.params['handle'])
            result = category.products
          else
            result = ShopProduct.all
          end
          
          result
        end
        
        def current_product(tag)
          result = nil
          
          if tag.locals.shop_product
            result = tag.locals.shop_product
          elsif tag.locals.page.shop_product_id
            result = ShopProduct.find(tag.locals.page.shop_product_id)
          elsif tag.attr['id']
            result = ShopProduct.find(tag.attr['id'])
          elsif tag.attr['sku']
            result = ShopProduct.find(:first, :conditions => {:sku => tag.attr['sku']})
          elsif tag.attr['name']
            result = ShopProduct.find(:first, :conditions => {:name => tag.attr['name']})
          elsif tag.attr['position']
            result = ShopProduct.find(:first, :conditions => {:position => tag.attr['position']})
          else
            result = ShopProduct.find(:first, :conditions => {:sku => tag.locals.page.slug})
          end
          
          result
        end
        
      end
    end
  end
end