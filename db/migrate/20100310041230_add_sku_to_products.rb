class AddSkuToProducts < ActiveRecord::Migration
  def self.up
    add_column :shop_products, :sku, :string
  end

  def self.down
    remove_column :shop_products, :sku
  end
end
