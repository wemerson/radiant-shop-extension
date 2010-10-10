class CreateDiscounts < ActiveRecord::Migration
  def self.up
    create_table :shop_discounts do |t|
      t.string    :name
      t.string    :code
      t.decimal   :amount
      
      t.datetime  :starts_at
      t.datetime  :finishes_at
      
      t.integer   :created_by
      t.integer   :updated_by
      
      t.timestamps
    end
    
    create_table :shop_discountables do |t|
      t.integer   :discount_id
      t.integer   :discounted_id
      t.string    :discounted_type
    end
    
  end

  def self.down
    remove_table :shop_discounts
    remove_table :shop_discounteds
  end
end
