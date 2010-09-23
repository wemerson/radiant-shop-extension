module Shop
  module Tags
    module Responses
      include Radiant::Taggable
      
      # Expand if there is a checkout response
      desc %{ Expand if there is a checkout response }
      tag 'response:checkout' do |tag|
        tag.locals.response_checkout = tag.locals.response.result[:results][:checkout]
        
        tag.expand if tag.locals.response_checkout.present?
      end
      
      # Expand if there is a checkout payment response
      desc %{ Expand if there is a checkout payment response }
      tag 'response:checkout:payment' do |tag|
        tag.expand if tag.locals.response_checkout[:payment].present?
      end
      
      # Expand if the payment was successful
      desc %{ Expand if the payment was successful }
      tag 'response:checkout:payment:if_success' do |tag|
        tag.expand if tag.locals.response_checkout[:payment][:success]
      end
      
      # Expand if the payment was not successful
      desc %{ Expand if the payment was not successful }
      tag 'response:checkout:payment:unless_success' do |tag|
        tag.expand unless tag.locals.response_checkout[:payment][:success]
      end
      
    end
  end
end