module Shop
  module Tags
    module Cart
      include Radiant::Taggable
      include ActionView::Helpers::NumberHelper
      
      # Expand if a user has started a cart
      desc %{ Expand if a user has started a cart }
      tag 'shop:if_cart' do |tag|
        tag.expand if Helpers.current_order(tag)
      end
      
      # Expand unless a user has started a cart
      desc %{ Expand unless a user has started a cart }
      tag 'shop:unless_cart' do |tag|
        tag.expand unless Helpers.current_order(tag)
      end
      
      # Expand the shopping cart instance
      # @param [Integer] id Id of the shopping cart (ShopOrder)
      tag 'shop:cart' do |tag|
        tag.locals.shop_order = Helpers.current_order(tag)
        tag.expand unless tag.locals.shop_order.nil?
      end
      
      # Display the cart id / status
      [:id, :status, :quantity, :weight].each do |symbol|
        desc %{ outputs the #{symbol} to the cart }
        tag "shop:cart:#{symbol}" do |tag|
          tag.locals.shop_order.send(symbol)
        end
      end
      
      # Display the total price of the items in the shopping basket.
      desc %{ Output the total price of the items in the shopping basket. }
      tag 'shop:cart:price' do |tag|
        attr = tag.attr.symbolize_keys
        order = tag.locals.shop_order
        
        number_to_currency(order.price.to_f, 
          :precision  =>(attr[:precision] || Radiant::Config['shop.price_precision']).to_i,
          :unit       => attr[:unit]      || Radiant::Config['shop.price_unit'],
          :separator  => attr[:separator] || Radiant::Config['shop.price_seperator'],
          :delimiter  => attr[:delimiter] || Radiant::Config['shop.price_delimiter'])
      end
      
    end
  end
end