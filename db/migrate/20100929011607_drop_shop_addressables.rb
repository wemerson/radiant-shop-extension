class DropShopAddressables < ActiveRecord::Migration
  def self.up
    drop_table :shop_addressables
    drop_table :shop_address_billings
    drop_table :shop_address_shippings
  end

  def self.down
    create_table :shop_addressables do |t|
      t.references  :address,   :polymorphic => true
      t.references  :addresser, :polymorphic => true
    end
    add_index :shop_addressables, :address_id
    add_index :shop_addressables, :addresser_id
    
    create_table :shop_address_billings do |t|
      t.references  :shop_address
    end
    add_index :shop_address_billings, :shop_address_id

    create_table :shop_address_shippings do |t|
      t.references  :shop_address
    end
  end
end
