class CreateShopLineItems < ActiveRecord::Migration
  def self.up
    create_table :shop_line_items do |t|
      t.integer   :quantity
      t.integer   :quantity, :default => 1
      
      t.integer   :created_by
      t.integer   :updated_by
      t.datetime  :created_at
      t.datetime  :updated_at
    end
  end

  def self.down
    drop_table :shop_line_items
  end
end
