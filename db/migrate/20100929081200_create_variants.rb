class CreateVariants < ActiveRecord::Migration
  def self.up
    create_table :shop_variants do |t|
      t.string  :name
      t.text    :options_json
    end
    
    create_table :shop_product_variants do |t|
      t.string  :name
      t.decimal :price
      
      t.integer :product_id
    end
  end

  def self.down
    remove_table :shop_variants
    remove_table :shop_product_variants
  end
end