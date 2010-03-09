class AddSequenceFields < ActiveRecord::Migration
	def self.up
		add_column :shop_products, :sequence, :integer
		add_column :shop_categories, :sequence, :integer
	end

	def self.down
		remove_column :shop_products, :sequence
		remove_column :shop_categories, :sequence
	end
end
