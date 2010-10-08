class FormCheckout
  include Forms::Models::Extension
  include Shop::Models::FormExtension
  
  attr_accessor :config, :data, :result, :gateway, :card
  
  def create
    find_current_order # locate the @order object
    
    create_result_object # A default response object

    # If the form was configured for gateway and we have a billing address
    if @order.billing.present?
      if gateway.present?
        prepare_gateway # Create the @gateway object
        prepare_credit_card if card.present?# Create the @card object
      
        if @result[:gateway] and @result[:card]
          purchase! # Use @card to pay through @gateway
          
          # We have a paid for order with a billing address
          if success?
            finalize_cart
            # The form was configured to send a payment email
            if mail.present?
              configure_invoice_mail # Create some configuration variables for mailing
            end
          else
            @result[:payment] = false
            @form.redirect_to = :back
          end
        end
      else
        @result[:gateway] = false
      end
    end
    @result
  end
  
  protected
  
  def create_result_object
    @result = {
      :order    => @order.id, # We return the order id so the thank you screen has access to it
      :payment  => nil,
      :card     => nil,
      :gateway  => nil,
      :message  => nil,
    }
  end
  
  # Creates a gateway instance variable based off the form configuration
  def prepare_gateway
    ActiveMerchant::Billing::Base.mode = gateway_mode
    begin
      @gateway = ActiveMerchant::Billing.const_get("#{gateway_name}Gateway").new(gateway_credentials)
      @result[:gateway] = true
    end
  end
  
  # Creates a payment object attached to the order
  def create_payment
    payment = ShopPayment.new({
      :order      => @order,
      :gateway    => gateway_name,
      :amount     => @order.price,
      :card_type  => card_type,
      :card_number=> card_number_secure
    })
    
    @order.update_attribute(:status, 'paid')
    
    @result[:payment] = payment.save
  end
  
  # Builds an ActiveMerchant card using the submitted card information
  def prepare_credit_card
    @card = ActiveMerchant::Billing::CreditCard.new({
      :number             => card_number,
      :month              => card_month,
      :year               => card_year,
      :first_name         => card_first_name,
      :last_name          => card_last_name,
      :verification_value => card_verification,
      :type               => card_type
    })
    
    if @card.valid?
      @result[:card]    = true
    else
      @result[:card]    = false
      @result[:message] = "Credit Card Invalid: #{@card.errors.full_messages.join('. ')}"
    end
  end
  
  # Sets up mail to send an invoice to the billing email address
  def configure_invoice_mail
    @form[:extensions][:mail] ||= {}
    @form[:extensions][:mail].merge!({
      :recipient  => @order.billing.email,
      :to         => @order.billing.email,
    })
    @form[:extensions][:mail].merge!(mail)
  end
  
  # Uses the gateway and card objects to carry out an ActiveMerchant purchase
  def purchase!
    result = @gateway.purchase(amount, @card, options)
    
    @result[:message] = result.message
    
    if result.success?
      create_payment
    end
  end
  
  def finalize_cart
    @result[:session] = { :shop_order => nil }  # We no longer need to store the current shop_roder
    @order.update_attribute(:status, 'paid')    # The order is now considered paid 
  end
  
  # Returns the configured gateway
  def gateway
    @config[:gateway]
  end
  
  # Returns the name of the gateway (Eway)
  def gateway_name
    gateway[:name]
  end
  
  # Returns Gateway username and password etc
  def gateway_credentials
    gateway[:credentials]
  end
  
  # Returns whether the form is configured as testing or production
  def gateway_mode
    @config[:test].present? ? :test : :production
  end
  
  # Returns the submitted card attributes
  def card
    @data[:card]
  end
  
  # Returns card number (1234123412341234)
  def card_number
    card[:number].to_s.gsub('-', '')
  end
  
  # Returns the last 4 card number digits (1234)
  def card_number_secure
    @card.display_number
  end
  
  # Returns card month (02)
  def card_month
    card[:month].to_i
  end
  
  # Returns card year (2010)
  def card_year
    card[:year].to_i
  end
  
  # Returns card type (visa)
  def card_type
    card[:type]
  end
  
  # Returns card verification number (123)
  def card_verification
    card[:verification].to_s
  end
  
  # Splits the card names into an array we can inspect
  def card_names
    return @card_names if @card_names.present?
    @card_names = @data[:card][:name].split(' ')
  end
  
  # Return all the strings bar the last on the card
  def card_first_name
    card_names[0, card_names.length - 1].join(' ') if card_names.present?
  end
  
  # Return the last string on the card
  def card_last_name
    card_names[-1] if card_names.present?
  end
  
  # Returns configured mail attributes
  def mail
    @config[:mail]
  end
  
  # Returns the amount to be charged, which is $10 on testing gateways
  def amount
    result = 0
    if gateway_mode === :test
      result = 1000
    else
      result = (@order.price * 100)
    end
    result
  end
  
  # Options for the gateway are created at config and runtime level
  def options
    @config[:options] ||= {}
    
    @config[:options][:order_id] = @order.id
    @config[:options].merge!(@data[:options]) if @data[:options].present?
          
    @config[:options]
  end
  
  # Will return true if the order is paid for and has a billing address
  def success?
    @result[:payment] === true
  end
    
end