class ChangeDiscountablesAddObserver < ActiveRecord::Migration
  def self.up
    add_column :shop_discountables, :created_by, :integer
    add_column :shop_discountables, :created_at, :datetime
    add_column :shop_discountables, :updated_by, :integer
    add_column :shop_discountables, :updated_at, :datetime
  end

  def self.down
    remove_column :shop_discountables, :created_by
    remove_column :shop_discountables, :created_at
    remove_column :shop_discountables, :updated_at
    remove_column :shop_discountables, :updated_by
  end
end
