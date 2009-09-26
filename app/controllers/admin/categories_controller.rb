class Admin::CategoriesController < Admin::ResourceController
	model_class Category
	helper :spm
	
	def index
		redirect_to :controller => 'admin/products', :action => 'index'
	end

	def move
		@category=Category.find(params[:id])
		case params[:d]
			when 'up'
				@category.update_attribute(:sequence, @category.sequence.to_i - 1 )
			when 'down'
				@category.update_attribute(:sequence, @category.sequence.to_i + 1 )
			when 'top'
				@category.update_attribute(:sequence, 1 )
			when 'bottom'
				@category.update_attribute(:sequence, Category.maximum(:sequence, :conditions => { :parent_id => @category.parent_id } ).to_i + 1)
		end
		redirect_to :controller => 'admin/products', :action => 'index'
	end
end
