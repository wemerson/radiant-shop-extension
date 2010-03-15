class ChangeToActsAsList < ActiveRecord::Migration
  def self.up    
    add_column :shop_products, :position, :integer
    add_column :shop_categories, :position, :integer
    
    ShopProduct.all.each { |product| product.position = product.sequence }
    ShopCategory.all.each { |category| category.position = category.sequence }
    
    remove_column :shop_products, :sequence
    remove_column :shop_categories, :sequence
  end

  def self.down
  end
end
