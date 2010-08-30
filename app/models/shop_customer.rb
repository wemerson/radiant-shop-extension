class ShopCustomer < User

  has_many  :orders,        :class_name => 'ShopOrder'
  has_many  :addressables,  :class_name => 'ShopAddressable', :as => :addresser
  has_many  :billings,      :through => :addressables, :source => :address, :source_type => 'ShopAddressBilling',   :uniq => true
  has_many  :shippings,     :through => :addressables, :source => :address, :source_type => 'ShopAddressShipping',  :uniq => true

  accepts_nested_attributes_for :orders, :allow_destroy => true

  def first_name
    self.name.split(' ')[0]
  end
  
  def last_name
    self.name.split(' ')[1]
  end
  
end