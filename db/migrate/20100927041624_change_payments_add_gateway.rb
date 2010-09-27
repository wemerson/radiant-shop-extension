class ChangePaymentsAddGateway < ActiveRecord::Migration
  def self.up
    add_column  :shop_payments, :gateway, :string
    add_index   :shop_payments, :gateway
  end

  def self.down
    remove_index  :shop_payments, :gateway
    remove_column :shop_payments, :gateway
  end
end
