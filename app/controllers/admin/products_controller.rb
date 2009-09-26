class Admin::ProductsController < Admin::ResourceController
	model_class Product
	helper :spm

	def upload_image
		@product=Product.find(params[:product_id])
		@image=@product.product_images.new(params[:product_image])
		@image.save!

		redirect_to :action => 'edit', :id => @product
	end

	def delete_image
		@image=ProductImage.find(params[:id])
		product_id=@image.product_id
		@image.destroy
		redirect_to :action => 'edit', :id => product_id
	end

	def move
		@product=Product.find(params[:id])
		case params[:d]
			when 'up'
				@product.update_attribute(:sequence, @product.sequence.to_i - 1 )
			when 'down'
				@product.update_attribute(:sequence, @product.sequence.to_i + 1 )
			when 'top'
				@product.update_attribute(:sequence, 1 )
			when 'bottom'
				@product.update_attribute(:sequence, nil)
		end
		redirect_to :controller => 'admin/products', :action => 'index'
	end
end
