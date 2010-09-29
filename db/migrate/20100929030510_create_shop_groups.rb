class CreateShopGroups < ActiveRecord::Migration
  def self.up
    create_table :shop_groups do |t|
      t.string :name
    end
    
    create_table :shop_groupings do |t|
      t.integer :product_id
      t.string  :group_id
    end
    add_index :shop_groupings, :product_id
    add_index :shop_groupings, :group_id
  end
  
  def self.down
    remove_table :shop_groups
    remove_table :shop_groupings
  end
end
