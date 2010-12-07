class ShopBilling < ShopAddress
  
  default_scope :conditions => { :of_type => 'billing' }
  
end