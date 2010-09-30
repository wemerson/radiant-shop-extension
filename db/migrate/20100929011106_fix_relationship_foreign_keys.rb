class FixRelationshipForeignKeys < ActiveRecord::Migration
  class ShopProduct < ActiveRecord::Base; end
  class ShopProductAttachment < ActiveRecord::Base; end
  class ShopLineItem < ActiveRecord::Base; end
  class ShopOrder < ActiveRecord::Base; end
  class ShopPayment < ActiveRecord::Base; end
    
  def self.up
    # Product - Category
    add_column  :shop_products, :category_id, :integer
    add_index   :shop_products, :category_id
    ShopProduct.all.each do |p|
      p.update_attribute(:category_id, p.shop_category_id)
    end
    remove_column :shop_products, :shop_category_id
    remove_index  :shop_products, :shop_category_id
    
    # ProductAttachment - Product
    add_column  :shop_product_attachments, :product_id, :integer
    add_index   :shop_product_attachments, :product_id
    ShopProductAttachment.all.each do |a|
      a.update_attribute(:product_id, a.shop_product_id)
    end
    remove_column :shop_product_attachments, :shop_product_id
    remove_index  :shop_product_attachments, :shop_product_id
    
    # LineItem - Order
    add_column  :shop_line_items, :order_id, :integer
    add_index   :shop_line_items, :order_id
    ShopLineItem.all.each do |i|
      i.update_attribute(:order_id, i.shop_order_id)
    end
    remove_column :shop_line_items, :shop_order_id
    remove_index  :shop_line_items, :shop_order_id
    
    # Order - Customer
    add_column  :shop_orders, :customer_id, :integer
    add_index   :shop_orders, :customer_id
    ShopOrder.all.each do |o|
      o.update_attribute(:customer_id, o.shop_customer_id)
    end
    remove_column :shop_orders, :shop_customer_id
    remove_index  :shop_orders, :shop_customer_id
    
    # Payment - Order
    add_column  :shop_payments, :order_id, :integer
    add_index   :shop_payments, :order_id
    ShopPayment.all.each do |p|
      p.update_attribute(:order_id, p.shop_order_id)
    end
    remove_column :shop_payments, :shop_order_id
    remove_index  :shop_payments, :shop_order_id
  end

  def self.down
    # Product - Category
    add_column  :shop_products, :shop_category_id, :integer
    add_index   :shop_products, :shop_category_id
    ShopProduct.all.each do |p|
      p.update_attribute(:shop_category_id, p.category_id)
    end
    remove_column :shop_products, :category_id
    remove_index  :shop_products, :category_id
    
    # ProductAttachment - Product
    add_column  :shop_product_attachments, :shop_product_id, :integer
    add_index   :shop_product_attachments, :shop_product_id
    ShopProductAttachment.all.each do |a|
      a.update_attribute(:shop_product_id, a.product_id)
    end
    remove_column :shop_product_attachments, :product_id
    remove_index  :shop_product_attachments, :product_id
    
    # LineItem - Order
    add_column  :shop_line_items, :shop_order_id, :integer
    add_index   :shop_line_items, :shop_order_id
    ShopLineItem.all.each do |i|
      i.update_attribute(:shop_order_id, i.order_id)
    end
    remove_column :shop_line_items, :order_id
    remove_index  :shop_line_items, :order_id
    
    # Order - Customer
    add_column  :shop_orders, :shop_customer_id, :integer
    add_index   :shop_orders, :shop_customer_id
    ShopOrder.all.each do |o|
      o.update_attribute(:shop_customer_id, o.customer_id)
    end
    remove_column :shop_orders, :customer_id
    remove_index  :shop_orders, :customer_id
    
    # Payment - Order
    add_column  :shop_payments, :shop_order_id, :integer
    add_index   :shop_payments, :shop_order_id
    ShopPayment.all.each do |p|
      p.update_attribute(:shop_order_id, p.order_id)
    end
    remove_column :shop_payments, :order_id
    remove_index  :shop_payments, :order_id
  end
end
