module Shop
  module Tags
    module Product
      include Radiant::Taggable
      include ActionView::Helpers::NumberHelper
      
      class TagError < StandardError; end
      
      desc %{ expands if there are products within the context }
      tag 'shop:if_products' do |tag|
        tag.expand unless Helpers.current_products(tag).empty?
      end
      
      desc %{ expands if there are no products within the context }
      tag 'shop:unless_products' do |tag|
        tag.expand if Helpers.current_products(tag).empty?
      end
      
      tag 'shop:products' do |tag|
        tag.expand
      end
      
      desc %{ iterates through each product within the scope }
      tag 'shop:products:each' do |tag|
        content   = ''
        products  = Helpers.current_products(tag)
        
        products.each do |product|
          tag.locals.shop_product = product
          content << tag.expand
        end
        content
      end
      
      tag 'shop:product' do |tag|
        tag.locals.shop_product = Helpers.current_product(tag)
        tag.expand unless tag.locals.shop_product.nil?
      end
      
      [:id, :name, :sku].each do |symbol|
        desc %{ outputs the #{symbol} to the products generated page }
        tag "shop:product:#{symbol}" do |tag|
          tag.locals.shop_product.send(symbol)
        end
      end
      
      desc %{ outputs the description to the products generated page }
      tag "shop:product:description" do |tag|
        unless tag.locals.shop_product.nil?
          parse(TextileFilter.filter(tag.locals.shop_product.description))
        end
      end
      
      desc %{ generates a link to the products generated page }
      tag 'shop:product:link' do |tag|
        product = tag.locals.shop_product
        options = tag.attr.dup
        attributes = options.inject('') { |s, (k, v)| s << %{#{k.downcase}="#{v}" } }.strip
        attributes = " #{attributes}" unless attributes.empty?
        
        text = tag.double? ? tag.expand : product.name
        
        %{<a href="#{product.slug}"#{attributes}>#{text}</a>}
      end
      
      desc %{ outputs the slug to the products generated page }
      tag 'shop:product:slug' do |tag|
        product = tag.locals.shop_product
        product.slug unless product.nil?
      end
      
      desc %{ output price of product }
      tag 'shop:product:price' do |tag|
        attr = tag.attr.symbolize_keys
        product = tag.locals.shop_product
                
        number_to_currency(product.price, 
          :precision  =>(attr[:precision] || Radiant::Config['shop_price_precision']).to_i,
          :unit       => attr[:unit]      || Radiant::Config['shop_price_unit'],
          :separator  => attr[:separator] || Radiant::Config['shop_price_seperator'],
          :delimiter  => attr[:delimiter] || Radiant::Config['shop_price_delimiter'])
      end
      
      desc %{ expands if the product has a valid image }
      tag 'shop:product:if_images' do |tag|
        tag.expand unless tag.locals.shop_product.images.empty?
      end
      
      desc %{ expands if the product does not have a valid image }
      tag 'shop:product:unless_images' do |tag|
        tag.expand if tag.locals.shop_product.images.empty?
      end
      
      tag 'shop:product:images' do |tag|
        tag.expand
      end
      
      desc %{ iterates through each of the products images }
      tag 'shop:product:images:each' do |tag|
        content = ''
        tag.locals.shop_product.images.each do |image|
          tag.locals.image = image
          content << tag.expand
        end
        content
      end
      
    end
  end
end