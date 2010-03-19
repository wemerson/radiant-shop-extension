class CreateOrdersProductsJoinTable < ActiveRecord::Migration
  def self.up
    create_table :orders_products, :id => false do |t|
      t.integer :order_id
      t.integer :product_id
    end
  end

  def self.down
    drop_table :orders_products
  end
end
