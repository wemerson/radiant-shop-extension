module Shop
  module Tags
    module Responses
      include Radiant::Taggable
      
      desc %{ Expand if there is a response to a specified for value }
      tag 'response:if_results' do |tag|
        extension = tag.attr['extension'].to_sym
        tag.locals.response_extension = tag.locals.response.result[:results][extension]
        
        tag.expand if tag.locals.response_extension.present?
      end
      
      
      desc %{ Expand if there is a response to a specified for value }
      tag 'response:unless_results' do |tag|
        extension = tag.attr['extension'].to_sym
        tag.locals.response_extension = tag.locals.response.result[:results][extension]
        
        tag.expand unless tag.locals.response_extension.present?
      end
      
      desc %{ Expand if there is a positive response to a specified for value of an extension
        
        <pre>
          <r:response:if_get extension='bogus_gateway' value='checkout'>yay</r:response:if_get>
        </pre>
      }
      tag 'response:if_get' do |tag|
        query = tag.attr['name'].to_sym
        result = tag.locals.response_extension[query]
        
        tag.expand if result.present? and result === true
      end
      
      desc %{ Expand if there is a negative response to a specified for value of an extension
        
        <pre>
          <r:response:unless_get extension='bogus_gateway' value='checkout'>no</r:response:unless_get>
        </pre>
      }
      tag 'response:unless_get' do |tag|
        query = tag.attr['name'].to_sym
        result = tag.locals.response_extension[query]
        
        tag.expand if !result.present? or result != true
      end
      
    end
  end
end