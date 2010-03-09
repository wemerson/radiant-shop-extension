module ShopHelper
	def custom_fields(classname=:category)
		Radiant::Config["shop.#{classname.to_s}_fields"].split(',').collect { |x| x.strip }
	end

	def humanize(text)
		ActiveSupport::Inflector::humanize(text)
	end

	def product_move_links(product)
		o=''
		o << link_to(image('shop/move_to_bottom', :alt => '|<'), admin_move_product_url(product, :d => :bottom))
		o << link_to(image('shop/move_lower', :alt => '<'), admin_move_product_url(product, :d => :down))
		o << link_to(image('shop/move_higher', :alt => '>'), admin_move_product_url(product, :d => :up))
		o << link_to(image('shop/move_to_top', :alt => '>|'), admin_move_product_url(product, :d => :top))
		o
	end

	def category_move_links(category)
		o=''
		o << link_to(image('shop/move_to_bottom', :alt => '|<'), admin_move_category_url(category, :d => :bottom))
		o << link_to(image('shop/move_lower', :alt => '<'), admin_move_category_url(category, :d => :down))
		o << link_to(image('shop/move_higher', :alt => '>'), admin_move_category_url(category, :d => :up))
		o << link_to(image('shop/move_to_top', :alt => '>|'), admin_move_category_url(category, :d => :top))
		o
	end
end
