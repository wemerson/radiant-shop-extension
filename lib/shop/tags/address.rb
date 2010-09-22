module Shop
  module Tags
    module Address
      include Radiant::Taggable
      
      # Expand if an address has been assigned to the order
      desc %{ Expand if an address has been assigned to the order }
      tag 'shop:if_address' do |tag|
        tag.expand if Shop::Tags::Helpers.current_address(tag).present?
      end
      
      # Expand if an address has not been assigned to the order
      desc %{ Expand if an address has not been assigned to the order }
      tag 'shop:unless_address' do |tag|
        tag.expand unless Shop::Tags::Helpers.current_address(tag).present?
      end
      
      # Expand if the address has been assigned to the order
      desc %{
        Expand if an address has been assigned to the order
      
        @type@ = (billing)|(shipping)
      }
      tag 'shop:address' do |tag|
        tag.locals.address = Shop::Tags::Helpers.current_address(tag)
        
        tag.expand if tag.locals.address.present?
      end
      
      [:name, :email, :unit, :street, :city, :country, :postcode].each do |method|
        tag "shop:address:#{method}" do |tag|
          tag.locals.address.send(method)
        end
      end
      
    end
  end
end
