class AddHandleToProducts < ActiveRecord::Migration
  def self.up
    add_column :shop_products, :handle, :string
  end

  def self.down
    remove_column :shop_products, :handle
  end
end
