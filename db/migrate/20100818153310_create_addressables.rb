class CreateAddressables < ActiveRecord::Migration
  def self.up
    create_table :shop_addressables do |t|
      t.integer   :address_id
      t.string    :address_type
      t.integer   :addresser_id
      t.string    :addresser_type
    end
    
    create_table :shop_address_billings do |t|
      t.integer   :shop_address_id
    end

    create_table :shop_address_shippings do |t|
      t.integer   :shop_address_id
    end
  end

  def self.down
    drop_table :shop_addressables
    drop_table :shop_address_billings
    drop_table :shop_address_shippings
  end
end
