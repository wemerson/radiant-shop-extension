module SpmHelper
	def custom_fields(classname=:category)
		Radiant::Config["simple_product_manager.#{classname.to_s}_fields"].split(',').collect { |x| x.strip }
	end

	def humanize(text)
		ActiveSupport::Inflector::humanize(text)
	end

	def product_move_links(product)
		o=''
		o << link_to(image('simple_product_manager/move_to_bottom', :alt => '|<'), admin_move_product_url(product, :d => :bottom))
		o << link_to(image('simple_product_manager/move_lower', :alt => '<'), admin_move_product_url(product, :d => :down))
		o << link_to(image('simple_product_manager/move_higher', :alt => '>'), admin_move_product_url(product, :d => :up))
		o << link_to(image('simple_product_manager/move_to_top', :alt => '>|'), admin_move_product_url(product, :d => :top))
		o
	end

	def product_image_move_links(product_image)
		o=''
		o << link_to(image('simple_product_manager/move_to_bottom', :alt => '|<'), admin_move_product_image_url(product_image, :d => :bottom))
		o << link_to(image('simple_product_manager/move_lower', :alt => '<'), admin_move_product_image_url(product_image, :d => :down))
		o << link_to(image('simple_product_manager/move_higher', :alt => '>'), admin_move_product_image_url(product_image, :d => :up))
		o << link_to(image('simple_product_manager/move_to_top', :alt => '>|'), admin_move_product_image_url(product_image, :d => :top))
		o
	end

	def category_move_links(category)
		o=''
		o << link_to(image('simple_product_manager/move_to_bottom', :alt => '|<'), admin_move_category_url(category, :d => :bottom))
		o << link_to(image('simple_product_manager/move_lower', :alt => '<'), admin_move_category_url(category, :d => :down))
		o << link_to(image('simple_product_manager/move_higher', :alt => '>'), admin_move_category_url(category, :d => :up))
		o << link_to(image('simple_product_manager/move_to_top', :alt => '>|'), admin_move_category_url(category, :d => :top))
		o
	end
end
