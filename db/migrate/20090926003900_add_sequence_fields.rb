class AddSequenceFields < ActiveRecord::Migration
	def self.up
		add_column :products, :sequence, :integer
		add_column :categories, :sequence, :integer
	end

	def self.down
		remove_column :products, :sequence
		remove_column :categories, :sequence
	end
end
