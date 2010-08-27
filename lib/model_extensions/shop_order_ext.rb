module ShopCart
  module ShopOrderExt
    def included(base)
      base.class_eval {
        has_one :shipment, :class_name => 'ShopShippingMethod', :foreign_key => 'order_id'
        has_one :billing, :class_name => 'ShopBillingMethod', :foreign_key => 'order_id'
        
        def add(id, quantity = nil)
          if line_items.exists?({:product_id => id})
            line_item = line_items.find(:first, :conditions => {:product_id => id})
            quantity = line_item.quantity += quantity.to_i
            line_item.update_attribute(:quantity, quantity)
          else
            line_items.create(:product_id => id, :quantity => quantity)
          end
        end

        def update(id, quantity)
          if quantity.to_i == 0
            remove(id)
          else
            line_item = line_items.find(:first, :conditions => {:product_id => id})
            line_item.update_attribute(:quantity, quantity.to_i)
            line_item
          end
        end

        def remove(id)
          line_item = line_items.find(:first, :conditions => {:product_id => id})
          line_item.destroy
          line_item
        end

        def clear
          line_items.destroy_all
        end

        def quantity
          line_items.inject(0) do |quantity, line_item|
            quantity + line_item.quantity.to_i
          end
        end

        def price
          line_items.inject(0.0) do |price, line_item|
            price + line_item.price.to_f
          end
        end

        def weight
          line_items.inject(0.0) do |weight, line_item|
            weight + line_item.weight.to_f
          end
        end
      }
    end
  end
end
