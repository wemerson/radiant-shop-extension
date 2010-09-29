class ShopGroupsChangeAddDescription < ActiveRecord::Migration
  def self.up
    add_column    :shop_groups, :description,   :text
    add_column    :pages,       :shop_group_id, :integer
  end

  def self.down
    remove_column :shop_groups, :description
    remove_column :pages,       :shop_group_id
  end
end
