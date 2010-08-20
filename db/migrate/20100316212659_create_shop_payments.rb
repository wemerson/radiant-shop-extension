class CreateShopPayments < ActiveRecord::Migration
  def self.up
    create_table :shop_payments do |t|
      t.float     :amount
      t.string    :type
      
      t.integer   :order_id
      
      t.integer   :created_by
      t.integer   :updated_by
      t.datetime  :created_at
      t.datetime  :updated_at
    end
  end

  def self.down
    drop_table :shop_payments
  end
end
