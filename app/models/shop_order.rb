class ShopOrder < ActiveRecord::Base
  
  has_many  :payments, :class_name => 'ShopPayment', :dependent => :destroy, :foreign_key => 'order_id'
  has_many  :line_items, :class_name => 'ShopLineItem', :dependent => :destroy, :foreign_key => 'order_id'
  has_many  :products, :class_name => 'ShopProduct', :through => :line_items, :foreign_key => 'product_id'
  
  has_many  :addressables,  :class_name => 'ShopAddressable', :as => :addresser
  has_many  :billings, :through => :addressables, :source => :address, :source_type => 'ShopAddressBilling', :uniq => true
  has_many  :shippings, :through => :addressables, :source => :address, :source_type => 'ShopAddressShipping', :uniq => true
  
  belongs_to :status, :class_name => 'ShopOrderStatus'
  
  belongs_to :created_by, :class_name => 'User'
  belongs_to :updated_by, :class_name => 'User'
  belongs_to :customer, :class_name => 'ShopCustomer'
  
  accepts_nested_attributes_for :line_items, :allow_destroy => true, :reject_if => :all_blank
  accepts_nested_attributes_for :payments, :allow_destroy => true, :reject_if => :all_blank
  
  validates_associated :customer
  
  def self.search(search)
    unless search.blank?
      queries = []
      queries << 'LOWER(status) LIKE (:term)'
      
      sql = queries.join(" OR ")
      conditions = [sql, {:term => "%#{search.downcase}%" }]
    else
      conditions = []
    end
    
    all({ :conditions => conditions })
  end
  
end
