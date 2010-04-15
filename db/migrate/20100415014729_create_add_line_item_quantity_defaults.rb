class CreateAddLineItemQuantityDefaults < ActiveRecord::Migration
  def self.up
    change_column :shop_line_items, :quantity, :integer, :default => 1
  end

  def self.down
    change_column :shop_line_items, :quantity, :integer, :default => nil
  end
end
