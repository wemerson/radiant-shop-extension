class RemovePaymentIdFromShopOrders < ActiveRecord::Migration
  def self.up
    remove_column :shop_orders, :payment_id
  end

  def self.down
    add_column :shop_orders, :payment_id, :integer
  end
end
