class AddSequenceFieldsToProductImages < ActiveRecord::Migration
	def self.up
		add_column :product_images, :sequence, :integer
	end

	def self.down
		remove_column :product_images, :sequence
	end
end
