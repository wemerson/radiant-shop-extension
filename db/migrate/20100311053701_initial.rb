class Initial < ActiveRecord::Migration
  def self.up
    create_table :shop_products do |t|
      t.string    :sku
      t.string    :name
      t.text      :description
      t.integer   :position
      t.boolean   :is_active, :default => true
      
      t.decimal   :price
      
      t.decimal   :weight
      t.decimal   :height
      t.decimal   :width
      t.decimal   :depth
      
      t.references :layout
      t.references :shop_categrory
      
      t.integer   :created_by
      t.integer   :updated_by
      
      t.timestamps
    end
    add_index :shop_products, :position
    add_index :shop_products, :shop_category_id
    
    create_table :shop_product_images do |t|
      t.integer   :position
      
      t.references  :image
      t.references  :shop_product
    end
    add_index :shop_product_images, :position
    add_index :shop_product_images, :image_id
    add_index :shop_product_images, :product_id
    
    create_table :shop_categories do |t|
      t.string      :handle
      t.text        :description
      t.integer     :position
      t.boolean     :is_active, :default => true
      
      t.references  :layout
      t.references  :product_layout
      
      t.integer     :created_by
      t.integer     :updated_by
      
      t.timestamps
    end
    
    create_table :shop_addressables do |t|
      t.references  :address, :polymorphic => true
      t.references  :addresser, :polymorphic => true
    end
    add_index :shop_addressables, :shop_address_id
    add_index :shop_addressables, :shop_addresser_id
    
    create_table :shop_addresses do |t|
      t.string      :unit
      t.string      :street
      t.string      :city
      t.string      :state
      t.string      :postcode
      t.string      :country
    end
    
    create_table :shop_address_billings do |t|
      t.references  :shop_address
    end
    add_index :shop_address_billings, :shop_address_id

    create_table :shop_address_shippings do |t|
      t.references  :shop_address
    end
    add_index :shop_address_shippings, :shop_address_id
    
    create_table :shop_line_items do |t|
      t.integer     :quantity, :default => 1
      
      t.references  :shop_order
      t.references  :shop_product
      
      t.integer     :created_by
      t.integer     :updated_by
      
      t.timestamps
    end
    add_index :shop_line_items, :shop_order_id
    add_index :shop_line_items, :shop_product_id
    
    create_table :shop_orders do |t|
      t.text        :notes
      
      t.references  :shop_customer
      t.references  :shop_order_status
      
      t.integer     :created_by
      t.integer     :updated_by
      
      t.timestamps
    end
    add_index :shop_orders, :shop_customer_id
    add_index :shop_orders, :shop_order_status_id
    
    create_table :shop_order_statuses do |t|
      t.string    :name
    end
    
    create_table :shop_payments do |t|
      t.float       :amount
      
      t.references  :shop_order
      t.references  :shop_payment_method
      
      t.integer     :created_by
      t.integer     :updated_by
      
      t.timestamps
    end
    add_index :shop_payments, :shop_order_id
    add_index :shop_payments, :shop_payment_method_id
    
    create_table :shop_payment_methods do |t|
      t.string      :name
    end
    
    add_column :pages, :shop_product_id, :integer
    add_column :pages, :shop_category_id, :integer
    
  end
  
  def self.down
    drop_table :shop_products
    drop_table :shop_product_images
    drop_table :shop_categories
    drop_table :shop_orders
    drop_table :shop_order_statuses
    drop_table :shop_addressables
    drop_table :shop_address_shippings
    drop_table :shop_address_billings
    drop_table :shop_addresses
    drop_table :shop_line_items
    drop_table :shop_orders
    drop_table :shop_payments
    drop_table :shop_payment_methods
    
    remove_column :pages, :shop_product_id
    remove_column :pages, :shop_category_id
  end
end
