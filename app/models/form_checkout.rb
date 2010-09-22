class FormCheckout
  include Forms::Models::Extension
  
  def create
    result = {}
    
    @success= true
    @order  = ShopOrder.find(@page.request[:session][:shop_order])
    
    if @config[:address]
      # If the form was configured for address
      result.merge! build_addresses
    end
    
    if @config[:gateway]
      # If the form was configured for gateway
      ActiveMerchant::Billing::Base.mode = :test if testing
      
      result.merge! build_gateway
      result.merge! build_card
      
      @gateway.purchase(@order.price, @card, @config[:order])
    end
    
    result
  end
  
  private
  
    # Assigns a shipping and billing address to the @order
    def build_addresses
      result    = {}
      billing   = @data['billing'] # Array of billing attributes
      shipping  = @data['shipping'] # Array of shipping attributes
            
      if billing.present?
        # Billing Address
        if billing['id'].present?
          # Use an existing Address and update its values
          @billing = ShopAddress.find(billing['id'])
          @billing.update_attributes(billing)
          @order.update_attribute(:billing_id, @billing.id)

        elsif @order.billing.present?
          # Use the current billing and update its values
          @billing = @order.billing
          @billing.update_attributes(billing)
          
        else
          # Create a new address with these attributes
          @order.update_attributes({ :billing_attributes => billing })
          @billing = @order.billing
          
        end
      end
      
      if shipping.present?
        # Shipping Address
        if shipping['id'].present?
          # Use an existing Address and update its values
          @shipping = ShopAddress.find(shipping['id'])
          @shipping.update_attributes(shipping)
          @order.update_attribute(:shipping_id, @shipping.id)
          
        elsif @order.shipping.present?
          # Use the current shipping and update its values
          @shipping = @order.shipping
          @shipping.update_attributes(shipping)
          
        elsif shipping.values.all?(&:blank?) or shipping == billing
          # We haven't set a shipping, or we have copied billing, so use billing
          @shipping = @billing
          @order.update_attribute(:shipping_id, @shipping.id)
          
        else
          # Create a new address with these attributes
          @order.update_attributes!({ :shipping_attributes => shipping })
          @shipping = @order.shipping
        end
      elsif billing.present?
        @shipping = @billing
        @order.update_attribute(:shipping_id, @shipping.id)
      end
      
      result  = {
        :checkout => {          
          :billing  => @order.billing.present? ? @order.billing : false,
          :shipping => @order.shipping.present? ? @order.shipping : false
        }
      }
      
      unless @order.billing.present? and @order.shipping.present?
        @form.redirect_to = :back
      end
      
      result
    end

    # Creates a gateway instance variable based off the form configuration
    def build_gateway
      @gateway = ActiveMerchant::Billing.const_get("#{gateway_name}Gateway").new(
        :username => gateway_username,
        :password => gateway_password,
        :merchant => gateway_merchant,
        :pem      => gateway_pem
      )

      result = {
        :checkout => {
          :gateway => true
        }
      }
    end

    # Builds an ActiveMerchant card using the submitted card information
    def build_card
      @card = ActiveMerchant::Billing::CreditCard.new(
        :number             => card_number,
        :month              => card_month,
        :year               => card_year,
        :first_name         => card_first_name,
        :last_name          => card_last_name,
        :verfication_value  => card_verification,
        :type               => card_type
      )

      result = {
        :checkout => {
          :card => true
        }
      }
    end
    
    def success?
      @success
    end
  
    def testing
      @config[:gateway][:testing].present?
    end
    
    def gateway_name
      @config[:gateway][:name]
    end
    
    def gateway_username
      @config[:gateway][:username]
    end
    
    def gateway_password
      @config[:gateway][:password]
    end
    
    def gateway_merchant
      @config[:gateway][:merchant]
    end
    
    def gateway_pem
      @config[:gateway][:pem]
    end
    
    def card_number
      @data['card']['number'].gsub('-', '')
    end
    
    def card_month
      @data['card']['month'].to_i
    end
    
    def card_year
      @data['card']['year'].to_i
    end
    
    def card_type
      @data['card']['type']
    end
    
    def card_verification
      @data['card']['verification']
    end
    
    def card_names
      return @card_names if @card_names.defined?
      @card_names = @data['card']['name'].split(' ')
    end
    
    def card_first_name
      card_names[0, card_names.length - 1]
    end
    
    def card_last_name
      card_names[-1]
    end
    
end