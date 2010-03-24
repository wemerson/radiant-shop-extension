class CreateShopAddresses < ActiveRecord::Migration
  def self.up
    create_table :shop_addresses do |t|
      t.string :country
      t.string :state
      t.string :city
      t.string :street
      t.string :unit
      t.string :postal_code      
      t.string :atype
      t.integer :customer_id
      t.timestamps
    end
  end

  def self.down
    drop_table :shop_addresses
  end
end
