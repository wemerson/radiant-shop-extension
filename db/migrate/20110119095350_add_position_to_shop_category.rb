class AddPositionToShopCategory < ActiveRecord::Migration
  def self.up
    add_column :shop_categories, :position, :integer
  end

  def self.down
    remove_column :shop_categories, :position
  end
end
