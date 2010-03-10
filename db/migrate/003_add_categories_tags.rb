class AddCategoriesTags < ActiveRecord::Migration
  def self.up
    add_column :shop_categories, :tags, :string
  end

  def self.down
    remove_column :shop_categories, :tags
  end
end
