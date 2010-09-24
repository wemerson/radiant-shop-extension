class FormCheckout
  include Forms::Models::Extension
  
  def create
    @result = {
      :billing  => false,
      :shipping => false,
      :gateway  => false,
      :card     => false,
      :payment  => false,
      :order    => false
    }
    
    @success= true
    @order  = ShopOrder.find(@page.request[:session][:shop_order])
    
    if @config[:address].present?
      # If the form was configured for address
      build_addresses
    end
    
    if @config[:gateway].present? and card
      # If the form was configured for gateway
      build_gateway
      build_card
      
      purchase
    end
    
    if @result[:payment] and @result[:payment][:success]
      if @config[:email].present?
        # If the form was configured to send a payment email
        build_email
      end
      
      @order.update_attribute(:status, 'paid')
      
      @result[:order] = { :id => @order.id, :status => @order.status }
    end
    
    @result
  end
  
  private
  
    # Assigns a shipping and billing address to the @order
    def build_addresses
      if billing.present?
        # We're going to create a billing object
        build_billing_address
      
        unless shipping.present? and @billing.valid?
          # We're going to assign shipping to billing
          @shipping = @billing
          @order.update_attribute(:shipping_id, @shipping.id)
        end
      end
      
      if shipping.present?
        build_shipping_address
      end
      
      @result[:billing]  = @order.billing.present? ? @order.billing : false
      @result[:shipping] = @order.shipping.present? ? @order.shipping : false
      
      unless @order.billing.present? and @order.shipping.present?
        @form.redirect_to = :back
      end
    end
    
    def build_billing_address
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
        @billing = ShopAddress.new(billing)
        if @billing.save
          @order.update_attribute(:billing_id, @billing.id)
        end

      end
    end
    
    def build_shipping_address
      # Shipping Address
      if shipping['id'].present?
        # Use an existing Address and update its values
        @shipping = ShopAddress.find(shipping['id'])
        if @shipping == @billing and shipping == billing
          # We have exactly the same shipping and billing data
          @shipping = @billing
          @order.update_attribute(:shipping_id, @billing.id)
        elsif (shipping.reject!{|k,v|k=='id'}).values.all?(&:blank?)
          # We have just passed the id and not the data
          @order.update_attribute(:shipping_id, @shipping.id)
        elsif @shipping == @billing and shipping != billing
          # We have conflicting data so create a new address
          # the id is rejected so we'll get a new address
          @order.update_attributes!({ :shipping_attributes => shipping })
          @shipping = @order.shipping
        end
        
      elsif @order.shipping.present?
        # Use the current shipping and update its values
        @shipping = @order.shipping
        @shipping.update_attributes(shipping)
        
      elsif shipping.values.all?(&:blank?) or shipping == billing
        # We haven't set a shipping, or we have copied billing, so use billing
        @shipping = @billing
        @order.update_attribute(:shipping_id, @billing.id)
        
      else
        # Create a new address with these attributes
        @order.update_attributes!({ :shipping_attributes => shipping })
        @shipping = @order.shipping
      end
    end

    # Creates a gateway instance variable based off the form configuration
    def build_gateway
      ActiveMerchant::Billing::Base.mode = :test if testing
      
      begin
        @gateway = ActiveMerchant::Billing.const_get("#{gateway}Gateway").new(gateway_credentials)
        @result[:gateway] = true
      end
    end

    # Builds an ActiveMerchant card using the submitted card information
    def build_card
      if card.present?
        @card = ActiveMerchant::Billing::CreditCard.new({
          :number             => card_number,
          :month              => card_month,
          :year               => card_year,
          :first_name         => card_first_name,
          :last_name          => card_last_name,
          :verification_value => card_verification,
          :type               => card_type
        })
        
        @result[:card] = {
          :valid  => @card.valid?
        }
      end
    end
    
    def build_email
      if @config[:mail]
        @form[:config][:mail] = {
          :recipient  => @order.billing.email,
          :to         => @order.billing.email,
        }
        @form[:config][:mail].merge!(@config[:mail])
      end
    end
    
    def purchase
      result = @gateway.purchase(amount, @card, options)
      
      @result[:payment] = {
        :success  => result.success?,
        :message  => result.message
      }
      
      unless result.success?
        @form.redirect_to = :back
      end
    end
    
    def success?
      @success
    end
  
    def testing
      @config[:test].present?
    end
    
    def billing
      billing   = @data['billing'] # Array of billing attributes      
    end
    
    def shipping
      shipping  = @data['shipping'] # Array of shipping attributes      
    end
    
    def gateway
      @config[:gateway][:name]
    end
    
    def gateway_credentials
      @config[:gateway][:credentials]
    end
    
    def card
      @data['card']
    end
    
    def card_number
      card['number'].to_s.gsub('-', '').to_i
    end
    
    def card_month
      card['month'].to_i
    end
    
    def card_year
      card['year'].to_i
    end
    
    def card_type
      card['type']
    end
    
    def card_verification
      card['verification']
    end
    
    def card_names
      return @card_names if @card_names.present?
      @card_names = @data['card']['name'].split(' ')
    end
    
    def card_first_name
      card_names[0, card_names.length - 1].join(' ') if card_names.present?
    end
    
    def card_last_name
      card_names[-1] if card_names.present?
    end
    
    def amount
      result = 0
      
      if testing
        result = 1000
      else
        result = (@order.price * 100)
      end
      
      result
    end
    
    def options
      @config[:options] ||= {}
      
      @config[:options][:order_id] = @order.id
      
      @config[:options]
    end
    
end