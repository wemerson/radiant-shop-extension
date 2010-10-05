module Shop
  module Tags
    module Category
      include Radiant::Taggable
      
      desc %{ expands if there are shop categories within the context }
      tag 'shop:if_categories' do |tag|
        tag.expand if Helpers.current_categories(tag).present?
      end
      
      desc %{ expands if there are not shop categories within the context }
      tag 'shop:unless_categories' do |tag|
        tag.expand unless Helpers.current_categories(tag).present?
      end
      
      tag 'shop:categories' do |tag|
        tag.locals.shop_categories = Helpers.current_categories(tag)
        tag.expand if tag.locals.shop_categories.present?
      end
      
      desc %{ iterates through each product category }
      tag 'shop:categories:each' do |tag|
        content = ''
        categories = tag.locals.shop_categories
        
        categories.each do |category|
          tag.locals.shop_category = category
          content << tag.expand
        end
        
        content
      end
      
      tag 'shop:category' do |tag|
        tag.locals.shop_category = Helpers.current_category(tag)
        tag.expand unless tag.locals.shop_category.nil?
      end
      
      tag 'shop:category:if_current' do |tag|
        
        if tag.locals.shop_category.handle == tag.locals.page.slug
          # Looking at the shop_category generated page
          tag.expand
        elsif tag.locals.page.shop_category_id == tag.locals.shop_category.id
          # A category page which is using this category
          tag.expand
        elsif tag.locals.shop_product.present?
          # A product page
          if tag.locals.shop_product.category == tag.locals.shop_category
            # Where the products category is this category
            tag.expand
          end
        end
        
      end
      
      [:id, :name, :handle, :slug].each do |symbol|
        desc %{ outputs the #{symbol} of the current shop category }
        tag "shop:category:#{symbol}" do |tag|
          tag.locals.shop_category.send(symbol)
        end
      end
      
      desc %{ outputs the description of the current shop category }
      tag "shop:category:description" do |tag|
        parse(TextileFilter.filter(tag.locals.shop_category.description))
      end
      
      desc %{ returns a link to the current category }
      tag 'shop:category:link' do |tag|
        category = tag.locals.shop_category
        options = tag.attr.dup
        attributes = options.inject('') { |s, (k, v)| s << %{#{k.downcase}="#{v}" } }.strip
        attributes = " #{attributes}" unless attributes.empty?
        
        text = tag.double? ? tag.expand : category.name
        
        %{<a href="#{category.slug}"#{attributes}>#{text}</a>}
      end
      
    end
  end
end