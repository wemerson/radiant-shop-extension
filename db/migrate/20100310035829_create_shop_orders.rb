class CreateShopOrders < ActiveRecord::Migration
  def self.up
    create_table :shop_orders do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :shop_orders
  end
end
