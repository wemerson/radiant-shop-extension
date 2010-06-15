class CreateShopProductImages < ActiveRecord::Migration
  def self.up
    create_table :shop_product_images do |t|
      t.column :image_id,   :integer
      t.column :product_id, :integer
      t.column :position,   :integer
    end
    remove_table :shop_product_assets
    
    add_column :shop_products, :image_id, :integer
    ShopProduct.all.each do |product|
      product.update_attribute('image_id', product.asset_id)
    end
    remove_column :shop_products, :asset_id
  end

  def self.down
    create_table :shop_product_assets do |t|
      t.column :asset_id,   :integer
      t.column :product_id, :integer
      t.column :position,   :integer
    end
    remove_table :shop_product_images
    
    add_column :shop_products, :asset_id, :integer
    ShopProduct.all.each do |product|
      product.update_attribute('asset_id', product.image_id)
    end
    remove_column :shop_products, :image_id
  end
end