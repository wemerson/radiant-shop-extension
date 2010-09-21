class FormCheckout
  include Forms::Models::Extension
  
  def create
    result = {}
    ActiveMerchant::Billing::Base.mode = :test if testing
    
    @success= true
    @order  = ShopOrder.find(@page.request[:session][:shop_order])
    
    if @config[:address]
      # If the form was configured for address
      result.merge build_addresses
    end
    
    if @config[:gateway]
      # If the form was configured for gateway
      result.merge build_gateway
      result.merge build_card
      
      @gateway.purchase(@order.price, @card, @config[:order])
    end
    
    result
  end
  
  # Assigns a shipping and billing address to the @order
  def build_addresses
    result = {}
    
  # Billing Address
    if @data['billing']['id'].present?
      # Use an existing Address and update its values
      @billing = ShopAddress.find(@data['billing']['id'])
      @billing.update_attributes(@data['billing'])
      
    elsif @order.billing.present?
      # Use the current billing and update its values
      @billing = @order.billing
      @billing.update_attributes(@data['billing'])
      
    else
      # Create a new address with these attributes
      @order.update_attributes({ :billing_attributes => @data['billing'] })
      @billing = @order.billing
      
    end
    
  # Shipping Address
    if @data['shipping']['id'].present?
      # Use an existing Address and update its values
      @shipping = ShopAddress.find(@data['shipping']['id'])
      @shipping.update_attributes(@data['shipping'])
      
    elsif @order.shipping.present?
      # Use the current shipping and update its values
      @shipping = @order.billing
      @shipping.update_attributes(@data['shipping'])
      
    elsif @data['shipping'].values.all?(&:blank?) or @data['shipping'] == @data['billing']
      # We haven't set a shipping, or we have copied billing, so use billing
      @shipping = @billing
      @order.update_attribute(:shipping_id, @shipping.id)
      
    else
      # Create a new address with these attributes
      @order.update_attributes!({ :shipping_attributes => @data['billing'] })
      @shipping = @order.shipping
    end
    
    if @order.billing.present? and @order.shipping.present?
      result  = {
        :checkout => {
          :addresses => {
            :billing  => @order.billing,
            :shipping => @order.shipping
          }
        }
      }
    else
      result = {
        :checkout => {
          :addresses =>  false
        }
      }
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
  
  private
    
    def success?
      @success
    end
  
    def testing
      @config[:testing].present?
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