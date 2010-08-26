class AddOrderAndProductToShopLineItem < ActiveRecord::Migration
  def self.up
    change_table :shop_line_items do |t|
      t.references :order
      t.references :product
    end

    add_index :shop_line_items, :order_id
    add_index :shop_line_items, :product_id
  end

  def self.down
    remove_index :shop_line_items, :product_id
    remove_index :shop_line_items, :order_id

    change_table :shop_line_items do |t|
      t.remove_references :product
      t.remove_references :order
    end
  end
end
