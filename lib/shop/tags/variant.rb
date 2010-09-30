module Shop
  module Tags
    module Variant
      include Radiant::Taggable
      include ActionView::Helpers::NumberHelper
      
      tag 'shop:product:variants' do |tag|
        tag.expand
      end
      
      tag 'shop:product:variants:each' do |tag|
        tag.expand
      end
      
      tag 'shop:product:variants:if_variants' do |tag|
        tag.expand
      end
      
      tag 'shop:product:variants:unless_variants' do |tag|
        tag.expand
      end
      
      tag 'shop:product:variant' do |tag|
        tag.expand
      end
      
      tag 'shop:product:variant:name' do |tag|
        tag.expand
      end
      
      tag 'shop:product:variant:price' do |tag|
        tag.expand
      end
      
      tag 'shop:product:variant:sku' do |tag|
        tag.expand
      end
      
      tag 'shop:product:variant:link' do |tag|
        tag.expand
      end
      
    end
  end
end