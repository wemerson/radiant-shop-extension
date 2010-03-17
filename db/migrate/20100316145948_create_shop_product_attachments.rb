class CreateShopProductAttachments < ActiveRecord::Migration
  def self.up
    create_table :shop_product_attachments do |t|
      t.column :asset_id,   :integer
      t.column :product_id, :integer
      t.column :position,   :integer
    end
  end

  def self.down
    drop_table :shop_product_attachments
  end
end