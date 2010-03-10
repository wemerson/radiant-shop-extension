class AddHandleToShopCategories < ActiveRecord::Migration
  def self.up
    add_column :shop_categories, :handle, :string
  end

  def self.down
    remove_column :shop_categories, :handle
  end
end
