class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :shop_products do |t|
      t.string  :title,       :limit => 255
      t.text    :description
      t.decimal :price,       :precision => 8,  :scale => 2
      t.boolean :is_visible,  :default => true
      t.integer :category_id, :null => false

      t.timestamps
    end
    
    add_index :shop_products, :category_id
    add_index :shop_products, :title
    add_index :shop_products, :price
  end

  def self.down
    drop_table :shop_products
  end
end
