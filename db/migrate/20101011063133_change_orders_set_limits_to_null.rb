class ChangeOrdersSetLimitsToNull < ActiveRecord::Migration
  def self.up
    change_column :shop_discounts, :starts_at,   :datetime, :default => nil
    change_column :shop_discounts, :finishes_at, :datetime, :default => nil
  end

  def self.down
    change_column :shop_discounts, :starts_at,   :datetime
    change_column :shop_discounts, :finishes_at, :datetime
  end
end
