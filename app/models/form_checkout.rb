class FormCheckout

  attr_reader :page, :config, :data, :errors

  def initialize(form, page, order)
     @data   = page.data
     @config = form.config[:checkout].symbolize_keys
     @order  = order
     
     ActiveMerchant::Billing::Base.mode = :test if testing
  end
  
  def process
    gateway  = build_gateway(@config[:gateway])
    card     = build_card(@data[:card])
    
    response = gateway.purchase(@order.price, card, @config[:order])
    
    if response.success?
      @order.update_attribute('status', :paid)
      @success = true
    else
      @success = false
    end
    
    @message = response.message
  end

  def build_gateway
    @gateway = ActiveMerchant::Billing.const_get("#{gateway[:name]}Gateway").new(
      :username => gateway_username,
      :password => gateway_password,
      :merchant => gateway_merchant,
      :pem      => gateway_pem
    )
  end

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
  end
  
  def private
    
    def success?
      @success
    end
  
    def testing
      @config[:testing].present?
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