class CreatePackages < ActiveRecord::Migration
  def self.up
    create_table :shop_packages do |t|
      t.string    :name
      t.string    :sku
      t.text      :description
      t.boolean   :is_active, :default => true
      
      t.decimal   :price
      
      t.integer   :created_by
      t.integer   :updated_by
      
      t.timestamps
    end
    
    create_table :shop_packings do |t|
      t.integer   :quantity,  :default => 1
      t.integer   :position
      
      t.integer   :product_id
      t.integer   :package_id      
    end
    
  end

  def self.down
    drop_table :shop_packages
    drop_table :shop_packings
  end
end
