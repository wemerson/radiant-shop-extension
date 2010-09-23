module Shop
  module Tags
    module Address
      include Radiant::Taggable
      
      # Expand if the address has been assigned to the order
      desc %{
        Expand if an address has been assigned to the order
      
        @type@ = (billing)|(shipping)
      }
      tag 'shop:cart:address' do |tag|
        Forms::Tags::Helpers.require!(tag,'shop:cart:address','type')
        
        tag.locals.address = Shop::Tags::Helpers.current_address(tag)
        
        tag.expand
      end
      
      # Expand if an address has been assigned to the order
      desc %{ Expand if an address has been assigned to the order }
      tag 'shop:cart:address:if_address' do |tag|
        tag.expand if tag.locals.address.present?
      end
      
      # Expand if an address has not been assigned to the order
      desc %{ Expand if an address has not been assigned to the order }
      tag 'shop:cart:address:unless_address' do |tag|
        tag.expand unless tag.locals.address.present?
      end
      
      [:id, :name, :email, :unit, :street, :city, :state, :country, :postcode].each do |method|
        tag "shop:cart:address:#{method}" do |tag|
          tag.locals.address.send(method) rescue nil
        end
      end
      
    end
  end
end
