module Shop
  module Models
    module User
    
      def self.included(base)
        base.class_eval do
          has_many  :orders,    :class_name => 'ShopOrder', :foreign_key => :customer_id
          has_many  :billings,  :through    => :orders
          has_many  :shippings, :through    => :orders
          
          accepts_nested_attributes_for :orders, :allow_destroy => true
        end
      end
      
    end
  end
end