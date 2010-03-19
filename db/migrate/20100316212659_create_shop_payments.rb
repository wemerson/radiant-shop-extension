class CreateShopPayments < ActiveRecord::Migration
  def self.up
    create_table :shop_payments do |t|
      t.float :amount
      t.integer :order_id
      t.string  :type
      t.timestamps
    end
  end

  def self.down
    drop_table :shop_payments
  end
end
