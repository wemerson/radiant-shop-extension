class ShopOrder < ActiveRecord::Base
  
  has_many  :payments,    :class_name => 'ShopPayment',   :dependent => :destroy
  has_many  :line_items,  :class_name => 'ShopLineItem',  :dependent => :destroy
  has_many  :products,    :class_name => 'ShopProduct',   :through => :line_items
  
  has_many  :addressables,:class_name => 'ShopAddressable', :as => :addresser
  has_many  :billings,    :through => :addressables,  :source => :address, :source_type => 'ShopAddressBilling',  :uniq => true
  has_many  :shippings,   :through => :addressables,  :source => :address, :source_type => 'ShopAddressShipping', :uniq => true
  
  belongs_to :status,     :class_name => 'ShopOrderStatus'
  
  belongs_to :created_by, :class_name => 'User'
  belongs_to :updated_by, :class_name => 'User'
  belongs_to :customer,   :class_name => 'ShopCustomer'
  
  before_create :set_status_new
  
  accepts_nested_attributes_for :line_items, :allow_destroy => true, :reject_if => :all_blank
  accepts_nested_attributes_for :payments, :allow_destroy => true, :reject_if => :all_blank
  
  def add(id, quantity = nil)
    if line_items.exists?({:product_id => id})
      line_item = line_items.find(:first, :conditions => {:product_id => id})
      quantity = line_item.quantity += quantity.to_i
      line_item.update_attribute(:quantity, quantity)
    else
      line_items.create(:product_id => id, :quantity => quantity)
    end
  end
  
  def update(id, quantity)
    if quantity.to_i == 0
      remove(id)
    else
      line_item = line_items.find(:first, :conditions => {:product_id => id})
      line_item.update_attribute(:quantity, quantity.to_i)
      line_item
    end
  end
  
  def remove(id)
    line_item = line_items.find(:first, :conditions => {:product_id => id})
    line_item.destroy
    line_item
  end
  
  def clear
    line_items.destroy_all
  end
  
  def quantity
    line_items.inject(0) do |quantity, line_item|
      quantity + line_item.quantity.to_i
    end
  end
  
  def price
    line_items.inject(0.0) do |price, line_item|
      price + line_item.price.to_f
    end
  end
  
  def weight
    line_items.inject(0.0) do |weight, line_item|
      weight + line_item.weight.to_f
    end
  end
  
  class << self
    def search(search)
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
  
private
  
  def set_status_new
    self.status << ShopOrderStatus.find_by_name(:new)
  end
  
end
