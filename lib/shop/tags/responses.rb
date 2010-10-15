module Shop
  module Tags
    module Responses
      include Radiant::Taggable
      
      # Expand if there is a checkout response
      desc %{ Expand if there is a checkout response }
      tag 'response:address' do |tag|
        tag.locals.response_address = tag.locals.response.result[:results][:address]
        
        tag.expand if tag.locals.response_address.present?
      end
      
      # Expand if the billing address was correct
      desc %{ Expand if the billing address was correct }
      tag 'response:address:if_billing' do |tag|
        tag.expand if tag.locals.response_address[:billing].present?
      end
      
      # Expand if the billing address was incorrect
      desc %{ Expand if the billing address was incorrect }
      tag 'response:address:unless_billing' do |tag|
        tag.expand unless tag.locals.response_address[:billing].present?
      end
      
      # Expand if the shipping address was correct
      desc %{ Expand if the shipping address was correct }
      tag 'response:address:if_shipping' do |tag|
        tag.expand if tag.locals.response_address[:shipping].present?
      end
      
      
      # Expand if the shipping address was incorrect
      desc %{ Expand if the shipping address was incorrect }
      tag 'response:address:unless_shipping' do |tag|
        tag.expand unless tag.locals.response_address[:shipping].present?
      end
      
      # Expand if there is a checkout payment response
      desc %{ Expand if there is a checkout payment response }
      tag 'response:checkout' do |tag|
        tag.locals.shop_order = Shop::Tags::Helpers.current_order(tag)
        tag.locals.response_checkout = tag.locals.response.result[:results][:checkout]
                
        tag.expand if tag.locals.shop_order.present? and tag.locals.response_checkout.present?
      end
            
      # Expand if there is a successful checkout payment response
      desc %{ Expand if there is a successful checkout payment response }
      tag 'response:checkout:if_success' do |tag|
        tag.expand if tag.locals.shop_order.paid?
      end
      
      # Expand if there is a successful checkout payment response
      desc %{ Expand if there is a successful checkout payment response }
      tag 'response:checkout:unless_success' do |tag|
        tag.expand unless tag.locals.shop_order.paid?
      end
      
    end
  end
end