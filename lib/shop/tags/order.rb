module Shop
  module Tags
    module Order
      include Radiant::Taggable
      include ActionView::Helpers::NumberHelper
    
      class ShopOrderTagError < StandardError; end
    
      # Begin a shopping cart, finds the shopping cart specified by id attribute,
      # or one described in the session.
      # @param [Integer] id Id of the shopping cart (ShopOrder)
      tag 'shop:cart' do |tag|
        tag.locals.shop_order = find_shop_order(tag)
        tag.expand unless tag.locals.shop_order.nil?
      end
    
      # Display the shop id / status
      [:id, :status].each do |symbol|
        desc %{ outputs the #{symbol} to the products generated page }
        tag "shop:cart:#{symbol}" do |tag|
          unless tag.locals.shop_order.nil?
            hash = tag.locals.shop_order
            hash[symbol]
          end
        end
      end
    
      # Display the number of items in the shopping basket.
      tag 'shop:cart:quantity' do |tag|
        tag.locals.shop_order.quantity
      end
    
      # This appears to be the total value of the shopping cart
      tag 'shop:cart:price' do |tag|
        attrs = tag.attr.symbolize_keys
        precision = attrs[:precision] || 2
        precision = precision.to_i
      
        number_to_currency(tag.locals.shop_order.price.to_f,
                           :precision => precision,
                           :unit => attrs[:unit] || "$",
                           :separator => attrs[:separator] || ".",
                           :delimiter => attrs[:delimiter] || ",")
      end
    
      # Total weight of all items in the shopping cart
      tag 'shop:cart:weight' do |tag|
        tag.locals.shop_order.weight
      end
    
      # Display all the items in the shopping cart
      tag 'shop:cart:items' do |tag|
        tag.expand
      end
    
      tag 'shop:cart:items:each' do |tag|
        content = ''
        tag.locals.shop_order.line_items.each do |line_item|
          tag.locals.shop_line_item = line_item
          content << tag.expand
        end
        content
      end
    
      tag 'shop:cart:item' do |tag|
        tag.locals.shop_line_item = find_shop_line_item(tag)
        tag.locals.shop_product = tag.locals.shop_line_item.product
      
        unless tag.locals.shop_line_item.nil?
          content = "<form action='/shop/cart/items/#{tag.locals.shop_line_item.id}' method='post'>"
          content << "<input type='hidden' name='_method' value='put' />"
          content << "<input type='hidden' name='shop_line_item[product_id]' value='#{tag.locals.shop_product.id}' />"
          content << tag.expand
          content << "<input type='submit' name='update_item' id='update_item#{tag.locals.shop_line_item.id}' value='Update' />"
          content << "</form>"
        else
          raise ShopOrderTagError, "Item can't be found"
        end
      end
    
      tag 'shop:cart:item:id' do |tag|
        tag.locals.shop_line_item.id
      end
    
      tag 'shop:cart:item:quantity' do |tag|
        tag.locals.shop_line_item.quantity
      end
  
      tag 'shop:cart:item:price' do |tag|
        attrs = tag.attr.symbolize_keys
        precision = attrs[:precision] || 2
        precision = precision.to_i
    
        number_to_currency(tag.locals.shop_line_item.price.to_f, 
                           :precision => precision,
                           :unit => attrs[:unit] || "$",
                           :separator => attrs[:separator] || ".",
                           :delimiter => attrs[:delimiter] || ",")
      end
  
      tag 'shop:cart:item:weight' do |tag|
        tag.locals.shop_line_item.weight
      end
  
      tag 'shop:cart:item:delete' do |tag|
        url = "/shop/cart/items/#{tag.locals.shop_line_item.id}/remove"
        title = "Remove #{tag.locals.shop_product.name}"
        text = "Remove"
      
        "<a href='#{url}' title='#{title}'>#{text}</a>"
      end
    
      tag 'shop:product' do |tag|
        tag.locals.shop_product = Helpers.current_product(tag)
        debugger
        unless tag.locals.shop_product.nil?
          content = "<form action='/shop/cart/items/' method='post'>"
          content << "<input type='hidden' name='shop_line_item[product_id]' value='#{tag.locals.shop_product.id}' />"
          content << tag.expand
          content << "<input type='submit' name='add_to_cart' id='add_to_cart_#{tag.locals.shop_product.id}' value='Add To Cart' />"
          content << "</form>"
        else 
          raise ShopOrderTagError, "Product can't be found"
        end
      end
    
      tag 'shop:cart:product' do |tag|
        tag.expand
      end
    
    protected
    
      def find_shop_order(tag)
        if tag.locals.shop_order
          tag.locals.shop_order
        elsif tag.attr['id']
          ShopOrder.find(tag.attr['id'])
        else
          ShopOrder.find(request.session[:shop_order])
        end
      end

      def find_shop_line_item(tag)
        if tag.locals.shop_line_item
          tag.locals.shop_line_item
        elsif tag.attr['product_id']
          tag.local.shop_order.line_items.find(:first, :conditions => {:shop_product_id => tag.attr['product_id']})
        end
      end
    
    end
  end
end