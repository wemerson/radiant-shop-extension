class ModifyCategoriesRemoveVariant < ActiveRecord::Migration
  def self.up
    remove_column :shop_categories, :variant_id
  end

  def self.down
    add_column :shop_categories, :variant_id, :integer
  end
end
