require 'spec/spec_helper'

describe FormCheckout do

  dataset :shop_orders, :pages, :forms, :shop_addresses
  
  before :each do
    @form = forms(:checkout)
    @page = pages(:home)
    @order = shop_orders(:one_item)
    
    @config   = ''
    @data     = { }
    @request  = {
      :session => {
        :shop_order => @order.id
      }
    }
    mock(@page).data { @data }
    mock(@page).request { @request }
    
    @form = FormCheckout.new(@form, @page)
  end
  
  
  describe '#initialize' do
    it 'should assign the instance variables' do

    end
  end
  
  describe '#create' do
    context 'addresses' do
      before :each do
        @config = <<-CONFIG
checkout:
  address:
    active: true
CONFIG
        mock(@form).config { @config }
      end
      it 'should build the addresses' do
        mock(@form).build_addresses { true }
      end
    end
    
    context 'gateway' do
      before :each do
        @config = <<-CONFIG
checkout:
  gateway:
    name: PayWay
    username: 123456
    password: abcdef
    merchant: test
    pem: /var/www/certificate.pem
CONFIG
        mock(@form).config { @config }
      end
      it 'should build the gateway' do
        mock(@form).build_gateway { true }
      end
      it 'should build the card' do
        mock(@form).build_card { true }
      end
    end
    
    context 'both' do
      before :each do
        @config = <<-CONFIG
checkout:
  address:
    active: true
  gateway:
    name: PayWay
    username: 123456
    password: abcdef
    merchant: test
    pem: /var/www/certificate.pem
CONFIG
        mock(@form).config { @config }
      end
      it 'should build the addresses' do
        mock(@form).build_addresses { true }
      end
      it 'should build the gateway' do
        mock(@form).build_gateway { true }
      end
      it 'should build the card' do
        mock(@form).build_card { true }
      end
    end
  end
  
  describe '#build_addresses' do
    context 'billing' do
      
    end
    
    # context 'ids exist' do
    #   @billing  = shop_addresses(:billing)
    #   @shipping =  shop_addresses(:shipping)
    #   
    #   @data = {
    #     'billing'   => { 'id' => @billing.id },
    #     'shipping'  => { 'id' => @shipping.id }
    #   }
    #   it 'should update their attributes and assign them to the order' do
    #     @form.build_addresses
    #     
    #     @order.billing_id.should === @billing.id
    #     @order.shipping_id.should === @shipping.id
    #   end
    # end
  end
  
  describe '#build_gateway' do
    
  end
  
  describe '#build_card' do
    
  end
  
  context 'private methods' do
  
    describe '#success?' do
    
    end
      
    describe '#testing' do
    
    end
    
    describe '#gateway_username' do
      
    end
    
    describe '#gateway_password' do
      
    end
    
    describe '#gateway_merchant' do
      
    end
    
    describe '#gateway_pem' do
      
    end
    
    describe '#card_number' do
      
    end
    
    describe '#card_month' do
      
    end
    
    describe '#card_year' do
      
    end
    
    describe '#card_type' do
      
    end
    
    describe '#card_verification' do
      
    end
    
    describe '#card_names' do
      
    end
    
    describe '#card_first_name' do
      
    end
    
    describe '#card_last_name' do
      
    end
    
  end

end