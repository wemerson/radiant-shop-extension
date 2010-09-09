class ShopOrder < ActiveRecord::Base
  
  has_many  :payments,    :class_name => 'ShopPayment',   :dependent => :destroy
  has_many  :line_items,  :class_name => 'ShopLineItem',  :dependent => :destroy
  
  has_many  :addressables,:class_name => 'ShopAddressable', :as => :addresser
  has_many  :billings,    :through => :addressables,  :source => :address, :source_type => 'ShopAddressBilling',  :uniq => true
  has_many  :shippings,   :through => :addressables,  :source => :address, :source_type => 'ShopAddressShipping', :uniq => true
  
  belongs_to :created_by, :class_name => 'User'
  belongs_to :updated_by, :class_name => 'User'
  belongs_to :customer,   :class_name => 'ShopCustomer', :foreign_key => :shop_customer_id
  
  accepts_nested_attributes_for :line_items,  :allow_destroy => true, :reject_if => :all_blank
  accepts_nested_attributes_for :payments,    :allow_destroy => true, :reject_if => :all_blank
  
  def add!(id, quantity = nil, type = nil)
    quantity  ||= 1
    type      ||= 'ShopProduct'
    
    if self.line_items.exists?({:item_id => id, :item_type => type})
      line_item = self.line_items.first(:conditions => {:item_id => id, :item_type => type})
      quantity  = line_item.quantity + quantity.to_i
      
      self.update!(line_item.id, quantity)
    else
      self.line_items.create!({:item_id => id, :item_type => type, :quantity => quantity})
    end
    
    true
  end
  
  def update!(id, quantity = 1)
    quantity = quantity.to_i
    if quantity <= 0
      remove!(id)
    else
      line_item = self.line_items.find(id)
      line_item.update_attribute(:quantity, quantity)
    end
    
    true
  end
  
  def remove!(id)
    line_item = line_items.find(id)
    line_item.destroy
    
    true
  end
  
  def clear!
    line_items.destroy_all
  end
  
  def quantity
    self.line_items.sum(:quantity)
  end
  
  def price
    price = 0
    self.line_items.map { |l| price += l.item.price }
    price * self.quantity
  end
  
  def weight
    weight = 0
    self.line_items.map { |l| weight += l.item.weight }
    weight * self.quantity
  end
  
  class << self
    def search(search = nil)
      unless search.blank?
        search = search.downcase
        
        queries = []
        queries << 'LOWER(status) LIKE (:term)'
        
        sql = queries.join(' OR ')
        
        # This looks tricky, but not subject to sql injection :-)
        conditions = [sql, {:term => "%#{search}%" }]
      else
        conditions = []
      end
      
      all(:conditions => conditions)
    end
    
    def params
      [ :id, :notes, :status ]
    end
  end
  
end
