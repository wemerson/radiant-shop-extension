class CreateShopOrders < ActiveRecord::Migration
  def self.up
    create_table :shop_orders do |t|
      t.integer :customer_id
      t.integer :payment_id
      t.string  :status # in_progress, new, canceled, returned, resumed, paid, shipped, balance_due

      t.integer :created_by
      t.integer :updated_by
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :shop_orders
  end
end
