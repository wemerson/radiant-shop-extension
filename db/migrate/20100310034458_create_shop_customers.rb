class CreateShopCustomers < ActiveRecord::Migration
  def self.up
    create_table :shop_customers do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :shop_customers
  end
end
