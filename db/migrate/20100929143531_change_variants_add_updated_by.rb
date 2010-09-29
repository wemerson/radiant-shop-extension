class ChangeVariantsAddUpdatedBy < ActiveRecord::Migration
  def self.up
    add_column :shop_variants,  :created_by_id,   :integer
    add_column :shop_variants,  :updated_by_id,   :integer
    add_column :shop_variants,  :created_at,      :datetime
    add_column :shop_variants,  :updated_at,      :datetime
    
    add_column :shop_groups,    :created_by_id,   :integer
    add_column :shop_groups,    :created_by_id,   :integer
    add_column :shop_groups,    :created_at,      :datetime
    add_column :shop_groups,    :updated_at,      :datetime
  end
  
  def self.down
    remove_column :shop_variants, :created_by_id
    remove_column :shop_variants, :created_by_id
    remove_column :shop_variants, :created_at
    remove_column :shop_variants, :updated_at
    
    remove_column :shop_groups,   :created_by_id
    remove_column :shop_groups,   :created_by_id
    remove_column :shop_groups,   :created_at
    remove_column :shop_groups,   :updated_at
  end
end
