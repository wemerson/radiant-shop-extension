class RemovePaymentMethods < ActiveRecord::Migration
  def self.up
    drop_table    :shop_payment_methods
    remove_index  :shop_payments, :shop_payment_method_id
    remove_column :shop_payments, :shop_payment_method_id
  end

  def self.down
    add_column  :shop_payments, :shop_pamyent_method_id, :integer
    add_index   :shop_payments, :shop_payment_method_id
  
    create_table :shop_payment_methods do |t|
      t.string      :name
    end
  end
end
