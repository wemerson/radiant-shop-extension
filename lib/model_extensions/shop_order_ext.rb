module ShopCart
  module ShopOrderExt
    def self.included(base)
      base.class_eval {
        has_one :shipment, :class_name => 'ShopShippingMethod', :foreign_key => 'order_id'
        has_one :billing, :class_name => 'ShopBillingMethod', :foreign_key => 'order_id'
        
        def add(id, quantity = nil)
          if self.line_items.exists?({:product_id => id})
            line_item = self.line_items.find(:first, :conditions => {:product_id => id})
            quantity = line_item.quantity += quantity.to_i
            line_item.update_attribute(:quantity, quantity)
          else
            self.line_items.create(:product_id => id, :quantity => quantity)
          end
        end

        def update(id, quantity)
          if quantity.to_i == 0
            remove(id)
          else
            self.line_items.find(:first, :conditions => {:product_id => id}).update_attribute(:quantity, quantity.to_i)
          end          
        end

        def remove(id)
          self.line_items.find(:first, :conditions => {:product_id => id}).destroy          
        end

        def clear
          self.line_items.destroy_all        
        end

        def quantity
          quantity = 0
          self.line_items.each do |line_item|
            quantity += line_item.quantity
          end
          quantity
        end

        def price
          price = 0.00
          self.line_items.each do |line_item|
            price += line_item.price.to_f
          end
          price
        end

        def weight
          weight = 0
          self.line_items.each do |line_item|
            total += line_item.weight.to_f
          end
          weight
        end
      }
    end    
  end
end
