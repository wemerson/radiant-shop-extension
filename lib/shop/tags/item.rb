module Shop
  module Tags
    module Item
      include Radiant::Taggable
      include ActionView::Helpers::NumberHelper
      
      # Expand if items are in cart
      desc %{ Expand if the user has added items to their cart }
      tag 'shop:cart:if_items' do |tag|
        tag.expand unless tag.locals.shop_order.line_items.empty?
      end
            
      # Expand in no items are in cart
      desc %{ Expand unless a user has added items to their cart }
      tag 'shop:cart:unless_items' do |tag|
        tag.expand if tag.locals.shop_order.line_items.empty?
      end
      
      # Expand to line items
      tag 'shop:cart:items' do |tag|
        tag.expand
      end
      
      # Iterate through each item in the cart
      desc %{ Iterate through each item in the cart }
      tag 'shop:cart:items:each' do |tag|
        content = ''
        items = tag.locals.shop_order.line_items
        
        items.each do |line_item|
          tag.locals.shop_line_item = line_item
          tag.locals.shop_product = line_item.item
          
          content << tag.expand
        end
        
        content
      end
      
      # Assigns the line item and expands the context
      desc %{ Expand the current line item }
      tag 'shop:cart:item' do |tag|
        tag.locals.shop_line_item = Helpers.current_line_item(tag)
        
        unless tag.locals.shop_line_item.nil?
          line_item = tag.locals.shop_line_item
          tag.locals.shop_product = line_item.item
          
          tag.expand
        end
      end
      
      # Output the line item id/quantity/weight
      [:id, :quantity].each do |symbol|
        desc %{ outputs the #{symbol} of the current cart item }
        tag "shop:cart:item:#{symbol}" do |tag|
          tag.locals.shop_line_item.send(symbol)
        end
      end
      
      # Output the related elements attributes
      [:name, :price, :weight].each do |symbol|
        desc %{ outputs the #{symbol} of the current cart item }
        tag "shop:cart:item:#{symbol}" do |tag|
          tag.locals.shop_line_item.item.send(symbol)
        end        
      end
      
      # Output the price of the line item
      desc %{ outputs the total price of the current cart item }
      tag 'shop:cart:item:price' do |tag|
        attr = tag.attr.symbolize_keys
        item = tag.locals.shop_line_item.item
        
        number_to_currency(item.price.to_f, 
          :precision  =>(attr[:precision] || Radiant::Config['shop.price_precision']).to_i,
          :unit       => attr[:unit]      || Radiant::Config['shop.price_unit'],
          :separator  => attr[:separator] || Radiant::Config['shop.price_seperator'],
          :delimiter  => attr[:delimiter] || Radiant::Config['shop.price_delimiter'])
      end
      
      # Output a link to remove the item from the cart
      desc %{ outputs a link to remove the item from the cart }
      tag 'shop:cart:item:remove' do |tag|
        item = tag.locals.shop_line_item
        options = tag.attr.dup
        attributes = options.inject('') { |s, (k, v)| s << %{#{k.downcase}="#{v}" } }.strip
        attributes = " #{attributes}" unless attributes.empty?
        
        text = tag.double? ? tag.expand : 'remove'
        
        %{<a href="/#{Radiant::Config['shop.url_prefix']}/cart/items/#{item.id}/destroy"#{attributes}>#{text}</a>}
      end
      
    end
  end
end