class ChangeCategoryAddVariantId < ActiveRecord::Migration
  def self.up
    add_column :shop_categories, :variant_id, :integer
  end

  def self.down
    remove_column :shop_categories, :variant_id
  end
end
