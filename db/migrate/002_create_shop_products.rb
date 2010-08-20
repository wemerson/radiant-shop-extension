class CreateShopProducts < ActiveRecord::Migration
  def self.up
    create_table :shop_products do |t|
      t.string    :title
      t.string    :sku
      t.string    :handle
      t.text      :description
      t.decimal   :price, :precision => 8, :scale => 2
      t.integer   :category_id, :null => false
      t.integer   :sequence
      t.boolean   :is_visible, :default => true

      t.integer   :created_by
      t.integer   :updated_by
      t.datetime  :created_at
      t.datetime  :updated_at
    end
        
    add_index :shop_products, :title
    add_index :shop_products, :price    
    add_index :shop_products, :category_id
  end

  def self.down
    drop_table :shop_products
  end
end
