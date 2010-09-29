class ShopCustomer < User
  
  include Scoped::Models::User::Scoped
  
  has_many  :orders,    :class_name => 'ShopOrder', :foreign_key => :customer_id
  has_many  :billings,  :through    => :orders
  has_many  :shippings, :through    => :orders
  
  accepts_nested_attributes_for :orders, :allow_destroy => true
  
  def first_name
    name = ''
    
    names = self.name.split(' ')
    if names.length > 1
      name = names[0, names.length-1].join(' ') 
    else
      name = names.join(' ')
    end
    
    name
  end
  
  def last_name
    name = ''
    
    names = self.name.split(' ')
    if names.length > 1
      name = names[-1]
    end
    
    name
  end
  
end