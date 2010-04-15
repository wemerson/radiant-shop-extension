module ShopCart
  module ShopLineItemExt
    def self.included(base)
      base.class_eval {
        before_validation :adjust_quantity

        def price
          product.price.to_f * self.quantity.to_f rescue 'Unable to calculate the price of the Product'
        end

        def weight
          product.weight.to_f * self.quantity.to_f rescue 'Unable to calculate the weight of the Product'
        end

        def adjust_quantity
          self.quantity = 1 if self.quantity.nil? || self.quantity < 1
        end
      }
    end
  end
end