class AddJsonFieldToModels < ActiveRecord::Migration
  def self.up
    add_column :shop_products, :json_field, :text
    add_column :shop_categories, :json_field, :text
  end

  def self.down
    remove_column :shop_products, :json_field
    remove_column :shop_categories, :json_field
  end
end
