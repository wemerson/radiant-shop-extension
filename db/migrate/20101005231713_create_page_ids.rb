class CreatePageIds < ActiveRecord::Migration
  def self.up
    add_column :shop_products, :page_id, :integer
    add_column :shop_categories, :page_id, :integer
  end

  def self.down
    remove_column :shop_products, :page_id, :integer
    remove_column :shop_categories, :page_id, :integer
  end
end
