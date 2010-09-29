class FormCheckout
  include Forms::Models::Extension
  
  attr_accessor :config, :data, :result, :gateway, :card, :billing, :shipping
  
  def create
    find_current_order # locate the @order object
    
    create_result_object # A default response object
    
    create_order_addresses # Create @order.billing and @order.shipping
    
    # If the form was configured for gateway and we have a billing address
    if gateway.present?
      prepare_gateway # Create the @gateway object
      prepare_credit_card if card.present?# Create the @card object
      
      if @result[:gateway] and @result[:card]
        purchase! # Use @card to pay through @gateway
      end
    
      # We have a paid for order with a billing address
      if success?
        # The form was configured to send a payment email
        if mail.present?
          configure_invoice_mail # Create some configuration variables for mailing
        end
      else
        @form.redirect_to = :back
      end
    end
    @result
  end
  
  private
    
    # Uses the page session data to find the current order
    def find_current_order
      @order  = ShopOrder.find(@page.request.session[:shop_order])
    end
    
    def create_result_object
      @result = {
        :order    => @order.id, # We return the order id so the thank you screen has access to it
        :billing  => @order.billing.present?,
        :shipping => @order.shipping.present?,
        :payment  => false,
        :card     => false,
        :gateway  => false,
        :message  => nil,
      }
    end
    
    # Assigns a shipping and billing address to the @order
    def create_order_addresses
      if billing.present?
        # We're going to create a billing object
        create_order_billing_address
        
        # We're going to assign shipping to billing because they didn't send shipping
        if !shipping.present? and @billing.present?
          @shipping = @billing
          @order.update_attribute(:shipping, @shipping)
        end
      end
      
      if shipping.present?
        create_order_shipping_address
      end
      
      if @order.billing.nil?
        @form.redirect_to = :back
      end
      
      @result[:billing]  = @order.billing.present?
      @result[:shipping] = @order.shipping.present?
    end
    
    # Attaches a billing address to the order (and current customer)
    def create_order_billing_address
      # Billing Address
      if billing[:id]
        begin
          # Use an existing Address and update its values
          @billing = current_customer.billings.find(billing[:id])
          @billing.update_attributes(billing)
          @order.update_attribute(:billing, @billing)
        rescue
          # We cant find that address for that user
        end
        
      elsif @order.billing.present?
        # Use the current billing and update its values
        @billing = @order.billing
        @billing.update_attributes(billing)
      
      else
        # Create a new address with these attributes
        @billing = ShopAddress.new(billing)
        if @billing.save
          @order.update_attribute(:billing, @billing)
        end
        
      end
      
    end
    
    # Attaches a shipping address to the order (and current customer)
    def create_order_shipping_address
      # Shipping Address
      
      if shipping[:id]
        # Use an existing Address and update its values
        begin
          @shipping = current_customer.shippings.find(shipping[:id])
          if @shipping == @billing and shipping == billing
            # We have exactly the same shipping and billing data
            @shipping = @billing
            @order.update_attribute(:shipping, @billing)
            
          elsif (shipping.reject!{|k,v| k == :id }).values.all?(&:blank?)
            # We have just passed the id and not the data
            @order.update_attribute(:shipping, @shipping)
            
          elsif @shipping == @billing and shipping != billing
            # We have conflicting data so create a new address
            # the id is rejected so we'll get a new address
            @order.update_attributes!({ :shipping_attributes => shipping })
            @shipping = @order.shipping
          end
        rescue
          # We cant find that address for that customer
        end
        
      elsif @order.shipping.present?
        # Use the current shipping and update its values
        @shipping = @order.shipping
        @shipping.update_attributes(shipping)
      
      elsif shipping.values.all?(&:blank?) or shipping == billing
        # We haven't set a shipping, or we have copied billing, so use billing
        @shipping = @billing
        @order.update_attribute(:shipping, @billing)
      
      else
        # Create a new address with these attributes
        @order.update_attributes!({ :shipping_attributes => shipping })
        @shipping = @order.shipping
      end
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
      
      @result[:card] = @card.valid?
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
    
    # Returns the current logged in ShopCustomer (if it exists)
    def current_customer
      return @shop_customer if @shop_customer.present?
      return current_user if current_user.present?
      @shop_customer = ShopCustomer.find(current_user.id)
    end
    
    # Returns an array of billing attributes
    def billing
      @data[:billing]
    end
    
    # Returns an array of shipping attributes
    def shipping
      @data[:shipping]
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
      @result[:payment] and @result[:billing]
    end
    
end