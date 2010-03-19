class RenameOrdersProductsColumns < ActiveRecord::Migration
  def self.up
    rename_column :orders_products, :order_id, :shop_order_id
    rename_column :orders_products, :product_id, :shop_product_id
  end

  def self.down
  end
end
