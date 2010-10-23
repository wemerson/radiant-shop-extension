class FormAddress
  include Forms::Models::Extension
  include Shop::Models::FormExtension
  
  attr_accessor :config, :data, :result, :gateway, :card, :billing, :shipping
  
  def create    
    find_current_order      # locate the @order object

    create_result_object    # A default response object
    
    create_order_addresses  # Process the addresses
    
    @result
  end
  
  protected
  
  def create_result_object
    @result = {
      :order    => @order.id, # We return the order id so the thank you screen has access to it
      :billing  => nil,
      :shipping => nil
    }
  end
  
  # Assigns a shipping and billing address to the @order
  def create_order_addresses
    if billing?
      # We're going to create a billing object
      create_order_billing_address
      
      # We're going to assign shipping to billing because they didn't send shipping
      if !shipping.present? and @billing.id
        @shipping = @billing
        @order.update_attribute(:shipping, @shipping)
      end
    end
    
    if shipping?
      create_order_shipping_address
    end
    
    unless (@billing.present? and @billing.valid?) and (@shipping.present? and @shipping.valid?)
      @form.redirect_to = :back
    end
    
    @result[:billing]  = (@billing.valid?  ? @billing.id  : false) rescue false
    @result[:shipping] = (@shipping.valid? ? @shipping.id : false) rescue false
  end
  
  # Attaches a billing address to the order (and current customer)
  def create_order_billing_address
    
    # Billing Address
    if billing[:id] and current_customer.present?
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
          @order.update_attributes({ :shipping_attributes => shipping })
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
      @order.update_attributes({ :shipping_attributes => shipping })
      @shipping = @order.shipping
    end
  end
  
  # Returns an array of billing attributes
  def billing
    @data[:billing]
  end
  
  # Returns an array of shipping attributes
  def shipping
    @data[:shipping]
  end
  
  # Returns whether form is configured for billing
  def billing?
    @config[:billing].present? and billing.present?
  end
  
  # Returns whether form is configured for shipping
  def shipping?
    @config[:shipping].present? and shipping.present?
  end
  
end