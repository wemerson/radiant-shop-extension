class ShopLineItem < ActiveRecord::Base
  belongs_to :order, :class_name => 'ShopOrder'
  belongs_to :product, :class_name => 'ShopProduct'

  def total
    (self.product.price * self.quantity).to_f
  end

end
