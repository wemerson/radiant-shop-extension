class ShopCustomer < User
  include Scoped::Models::User::Scoped
  
  has_many  :orders,        :class_name => 'ShopOrder'
  has_many  :billings,      :through => :orders
  has_many  :shippings,     :through => :orders
  
  accepts_nested_attributes_for :orders, :allow_destroy => true
  
  def first_name
    self.name.split(' ')[0]
  end
  
  def last_name
    self.name.split(' ')[1]
  end
  
end