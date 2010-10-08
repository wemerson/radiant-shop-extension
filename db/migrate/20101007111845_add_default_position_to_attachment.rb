class AddDefaultPositionToAttachment < ActiveRecord::Migration
  def self.up
    change_column :shop_product_attachments, :position, :integer, :default => 1, :allow_null => false
  end

  def self.down
    change_column :shop_product_attachments, :position, :integer
  end
end
