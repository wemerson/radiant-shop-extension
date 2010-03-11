class ShopCustomer < User
  has_many :orders, :class_name => 'ShopOrder'

  def first_name
    self.name.split(" ")[0]
  end

  def last_name
    self.name.split(" ")[1]
  end
end
