class CreateShopOrderStatuses < ActiveRecord::Migration
  def self.up
    create_table :shop_order_statuses do |t|
      t.string :status
      t.string :description
      t.timestamps
    end
  end

  def self.down
    drop_table :shop_order_statuses
  end
end
