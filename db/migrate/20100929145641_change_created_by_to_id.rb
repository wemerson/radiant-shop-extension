class ChangeCreatedByToId < ActiveRecord::Migration
  def self.up
    add_column :shop_products,    :created_by_id, :integer
    add_column :shop_products,    :updated_by_id, :integer
    remove_column :shop_products, :created_by
    remove_column :shop_products, :updated_by
    
    add_column :shop_categories,    :created_by_id, :integer
    add_column :shop_categories,    :updated_by_id, :integer
    remove_column :shop_categories, :created_by
    remove_column :shop_categories, :updated_by

    add_column :shop_product_attachments,    :created_by_id, :integer
    add_column :shop_product_attachments,    :updated_by_id, :integer
    remove_column :shop_product_attachments, :created_by
    remove_column :shop_product_attachments, :updated_by
    
    add_column :shop_addresses, :created_by_id, :integer
    add_column :shop_addresses, :updated_by_id, :integer
    add_column :shop_addresses, :created_at, :datetime
    add_column :shop_addresses, :updated_at, :datetime
    
    add_column :shop_orders,    :created_by_id, :integer
    add_column :shop_orders,    :updated_by_id, :integer
    remove_column :shop_orders, :created_by
    remove_column :shop_orders, :updated_by
    
    add_column :shop_line_items,    :created_by_id, :integer
    add_column :shop_line_items,    :updated_by_id, :integer
    remove_column :shop_line_items, :created_by
    remove_column :shop_line_items, :updated_by
    
    add_column :shop_payments,    :created_by_id, :integer
    add_column :shop_payments,    :updated_by_id, :integer
    remove_column :shop_payments, :created_by
    remove_column :shop_payments, :updated_by
  end

  def self.down
    remove_column :shop_products, :created_by_id, :integer
    remove_column :shop_products, :updated_by_id, :integer
    add_column :shop_products,    :created_by,    :integer
    add_column :shop_products,    :updated_by,    :integer
        
    remove_column :shop_categories, :created_by_id, :integer
    remove_column :shop_categories, :updated_by_id, :integer
    add_column :shop_categories,    :created_by,    :integer
    add_column :shop_categories,    :updated_by,    :integer
    
    remove_column :shop_product_attachments,  :created_by_id, :integer
    remove_column :shop_product_attachments,  :updated_by_id, :integer
    add_column :shop_product_attachments,     :created_by,    :integer
    add_column :shop_product_attachments,     :updated_by,    :integer    
    
    remove_column :shop_addresses, :created_by_id
    remove_column :shop_addresses, :updated_by_id
    remove_column :shop_addresses, :created_at
    remove_column :shop_addresses, :updated_at
    
    remove_column :shop_orders, :created_by_id
    remove_column :shop_orders, :updated_by_id
    add_column :shop_orders,    :created_by,  :integer
    add_column :shop_orders,    :updated_by,  :integer
    
    remove_column :shop_line_items, :created_by_id
    remove_column :shop_line_items, :updated_by_id
    add_column :shop_line_items,    :created_by,  :integer
    add_column :shop_line_items,    :updated_by,  :integer
    
    remove_column :shop_payments, :created_by_id
    remove_column :shop_payments, :updated_by_id
    add_column :shop_payments,    :created_by,  :integer
    add_column :shop_payments,    :updated_by,  :integer
  end
end
