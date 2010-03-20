class CreateShopLineItems < ActiveRecord::Migration
  def self.up
    create_table :shop_line_items do |t|
      t.integer :product_id
      t.integer :quantity
      t.integer :order_id
      t.timestamps
    end
  end

  def self.down
    drop_table :shop_line_items
  end
end
