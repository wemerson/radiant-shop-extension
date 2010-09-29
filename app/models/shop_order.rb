class ShopOrder < ActiveRecord::Base
  
  default_scope :order => 'shop_orders.updated_at DESC'
  
  has_one   :payment,     :class_name => 'ShopPayment',   :foreign_key => :order_id,  :dependent => :destroy
  has_many  :line_items,  :class_name => 'ShopLineItem',  :foreign_key => :order_id,  :dependent => :destroy
  
  belongs_to :billing,    :class_name => 'ShopAddress'
  belongs_to :shipping,   :class_name => 'ShopAddress'
  belongs_to :created_by, :class_name => 'User'
  belongs_to :updated_by, :class_name => 'User'
  belongs_to :customer,   :class_name => 'ShopCustomer'
  
  accepts_nested_attributes_for :line_items,  :reject_if => :all_blank
  accepts_nested_attributes_for :billing,     :reject_if => :all_blank
  accepts_nested_attributes_for :shipping,    :reject_if => :all_blank
  
  def add!(id, quantity = nil, type = nil)
    result = true
    
    quantity  ||= 1
    type      ||= 'ShopProduct'
    
    if self.line_items.exists?({:item_id => id, :item_type => type})
      line_item = self.line_items.first(:conditions => {:item_id => id, :item_type => type})
      quantity  = line_item.quantity + quantity.to_i
      
      self.update!(line_item.id, quantity)
    else
      self.line_items.create!({:item_id => id, :item_type => type, :quantity => quantity})
    end
    
    result
  end
  
  def update!(id, quantity = 1)
    result = true
    
    quantity = quantity.to_i
    if quantity <= 0
      remove!(id)
    else
      line_item = self.line_items.find(id)
      line_item.update_attribute(:quantity, quantity)
    end
    
    result
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
    self.line_items.map { |l| price += l.price }
    price
  end
  
  def weight
    weight = 0
    self.line_items.map { |l| weight += l.weight }
    weight
  end
  
  def new?
    self.status === 'new'
  end
  
  def paid?
    return false unless self.payment.present?
    self.payment.amount === self.price and self.status === 'paid'
  end
  
  def shipped?
    self.status === 'shipped'
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
