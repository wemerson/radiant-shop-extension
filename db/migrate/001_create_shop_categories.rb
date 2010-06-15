class CreateShopCategories < ActiveRecord::Migration
  def self.up
    create_table :shop_categories do |t|
      t.string  :title
      t.string  :sku
      t.string  :handle
      t.text    :description
      t.integer :position
      t.boolean :is_visible, :default => true
      
      t.integer :created_by
      t.integer :updated_by
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table  :shop_product_categories
  end
end
