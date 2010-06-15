class ShopCustomer < User
  has_many :orders, :class_name => 'ShopOrder', :foreign_key => :customer_id
  has_many :addresses, :class_name => 'ShopAddress', :foreign_key => :customer_id

  accepts_nested_attributes_for :orders, :allow_destroy => true
  accepts_nested_attributes_for :addresses, :allow_destroy => true, :reject_if => :all_blank

  def first_name
    self.name.split(" ")[0]
  end

  def last_name
    self.name.split(" ")[1]
  end
  
end
