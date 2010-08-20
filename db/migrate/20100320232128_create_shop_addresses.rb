class CreateShopAddresses < ActiveRecord::Migration
  def self.up
    create_table :shop_addresses do |t|
      t.string    :unit
      t.string    :street
      t.string    :city
      t.string    :state
      t.string    :postcode
      t.string    :country
    end
  end

  def self.down
    drop_table :shop_addresses
  end
end
