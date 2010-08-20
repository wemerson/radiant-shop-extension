class CleanUp < ActiveRecord::Migration
  
  # This migration drops a lot of columns which aren't being used, and may never be
  
  def self.up
    remove_column :shop_categories, :tags rescue nil
    remove_column :shop_categories, :parent_id rescue nil
    remove_column :shop_categories, :json_field rescue nil
    remove_column :shop_categories, :sequence rescue nil
    remove_column :shop_categories, :sku rescue nil
    
    remove_column :shop_products,   :json_field rescue nil
    remove_column :shop_products,   :sequence rescue nil
    
    drop_table :shop_product_attachments rescue nil
    drop_table :shop_product_assets rescue nil
    
    remove_column :users, :reference rescue nil
    remove_column :users, :organization rescue nil
        
    add_column :shop_products, :created_by, :integer rescue nil
    add_column :shop_products, :updated_by, :integer rescue nil
    add_column :shop_products, :updated_at, :datetime rescue nil
    add_column :shop_products, :created_at, :datetime rescue nil
    
    add_column :shop_categories, :created_by, :integer rescue nil
    add_column :shop_categories, :updated_by, :integer rescue nil
    add_column :shop_categories, :updated_at, :datetime rescue nil
    add_column :shop_categories, :created_at, :datetime rescue nil
    
    add_column :shop_orders, :created_by, :integer rescue nil
    add_column :shop_orders, :updated_by, :integer rescue nil
    add_column :shop_orders, :updated_at, :datetime rescue nil
    add_column :shop_orders, :created_at, :datetime rescue nil
    
    add_column :shop_products, :name, :string
    ShopProduct.all.each do |s|
      s.update_attribute('name', s.title)
    end
    remove_column :shop_products, :title, :string
    
    add_column :shop_categories, :name, :string
    ShopCategory.all.each do |c|
      s.update_attribute('name', c.title)
    end
    remove_column :shop_categories, :title, :string
  end

  def self.down
    
  end
end
