class RemoveShopProductAttachments < ActiveRecord::Migration
  def self.up
    drop_table :shop_product_attachments
  end

  def self.down
    #cant undo
  end
end