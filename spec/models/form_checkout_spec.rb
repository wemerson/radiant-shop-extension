require 'spec/spec_helper'

describe FormCheckout do

  dataset :shop_orders, :pages, :forms, :shop_addresses
  
  before :each do
    @form = forms(:checkout)
    @page = pages(:home)
    @order = shop_orders(:one_item)
    
    @data     = { }
    @request  = {
      :session => {
        :shop_order => @order.id
      }
    }

    stub(@page).data    { @data }
    stub(@page).request { @request }
  end
  
  describe '#initialize' do
    it 'should assign the instance variables' do
      
    end
  end
  
  describe '#create' do
    context 'addresses' do
      before :each do
        @form[:config] = {
          :checkout   => {
            :address  => {
              :enabled => true
            }
          }
        }
      end
      
      context 'sending ids' do
        context 'both billing and shipping' do
          it 'should assign that address to the order billing and shipping' do
            @data = { 
              'billing' => { 'id' => shop_addresses(:billing).id },
              'shipping' => { 'id' => shop_addresses(:shipping).id }
            }
            
            @checkout = FormCheckout.new(@form, @page)
            @checkout.create
            
            shop_orders(:one_item).billing.should  === shop_addresses(:billing)
            shop_orders(:one_item).shipping.should === shop_addresses(:shipping)
          end
        end
        context 'just billing' do
          it 'should assign shipping to be billing' do
            @data = {
              'billing' => { 'id' => shop_addresses(:billing).id }
            }
            
            @checkout = FormCheckout.new(@form, @page)
            @checkout.create
            
            shop_orders(:one_item).billing.should  === shop_addresses(:billing)
            shop_orders(:one_item).shipping.should === shop_addresses(:billing)
          end
        end
      end
      
      context 'existing addresses' do
        it 'should keep them assigned and update them' do
          shop_orders(:one_item).update_attributes({ 
            :billing_id   => shop_addresses(:billing).id,
            :shipping_id  => shop_addresses(:shipping).id,
          })
          
          @data = {
            'billing'   => { 'name' => 'new billing' },
            'shipping'  => { 'name' => 'new shipping' }
          }
          
          @checkout = FormCheckout.new(@form, @page)
          @checkout.create
          
          shop_orders(:one_item).billing.should === shop_addresses(:billing)
          shop_addresses(:billing).name.should  === 'new billing'
          shop_orders(:one_item).shipping.should=== shop_addresses(:shipping)
          shop_addresses(:shipping).name.should === 'new shipping'
        end
      end
      
      context 'new addresses' do
        context 'both billing and shipping sent' do
          it 'should create new addresses' do
            @data = {
              'billing'   => { 'name' => 'b_n', 'email' => 'b_e', 'street' => 'b_s', 'city' => 'b_c', 'state' => 'b_s', 'country' => 'b_c', 'postcode' => 'b_p' },
              'shipping'  => { 'name' => 's_n', 'email' => 's_e', 'street' => 's_s', 'city' => 's_c', 'state' => 's_s', 'country' => 's_c', 'postcode' => 's_p' }
            }
          
            @checkout = FormCheckout.new(@form, @page)
            @checkout.create
          
            shop_orders(:one_item).billing.name.should  === 'b_n'
            shop_orders(:one_item).shipping.name.should === 's_n'
          end
        end
        context 'only billing sent' do
          it 'should copy billing to shipping' do
            @data = {
              'billing'   => { 'name' => 'b_n', 'email' => 'b_e', 'street' => 'b_s', 'city' => 'b_c', 'state' => 'b_s', 'country' => 'b_c', 'postcode' => 'b_p' }
            }
          
            @checkout = FormCheckout.new(@form, @page)
            @checkout.create
          
            shop_orders(:one_item).billing.name.should  === 'b_n'
            shop_orders(:one_item).shipping.should === shop_orders(:one_item).billing
          end
        end
      end
      
      context 'result string' do
        context 'success' do
          it 'should return a success string' do
            @data = {
              'billing'   => { 'name' => 'b_n', 'email' => 'b_e', 'street' => 'b_s', 'city' => 'b_c', 'state' => 'b_s', 'country' => 'b_c', 'postcode' => 'b_p' },
              'shipping'  => { 'name' => 's_n', 'email' => 's_e', 'street' => 's_s', 'city' => 's_c', 'state' => 's_s', 'country' => 's_c', 'postcode' => 's_p' }
            }
          
            @checkout = FormCheckout.new(@form, @page)
            result = @checkout.create
            
            result[:checkout][:billing][:name].should === 'b_n'
            result[:checkout][:shipping][:name].should === 's_n'
          end
        end
        context 'failure' do
          it 'should set false to the nil billing' do
            @data = {
              'shipping'  => { 'name' => 's_n', 'email' => 's_e', 'street' => 's_s', 'city' => 's_c', 'state' => 's_s', 'country' => 's_c', 'postcode' => 's_p' }
            }
            
            @checkout = FormCheckout.new(@form, @page)
            result = @checkout.create
            
            result[:checkout][:billing].should === false
            result[:checkout][:shipping].should_not === false
          end
          it 'should set billing to the nil shipping' do
            @data = {
              'billing'   => { 'name' => 'b_n', 'email' => 'b_e', 'street' => 'b_s', 'city' => 'b_c', 'state' => 'b_s', 'country' => 'b_c', 'postcode' => 'b_p' }
            }
            
            @checkout = FormCheckout.new(@form, @page)
            result = @checkout.create
            
            result[:checkout][:billing].should_not === false
            result[:checkout][:shipping].should === result[:checkout][:billing]
          end
          it 'should set false to the nil objects' do
            @checkout = FormCheckout.new(@form, @page)
            result = @checkout.create
            
            result[:checkout][:billing].should === false
            result[:checkout][:shipping].should === false
          end
        end
      end
    end
    
    context 'gateway' do
      before :each do
        @form[:config] = {
          :checkout   => {
            :gateway  => {
              :name     => 'PayWay',
              :username => 'abcdefgh',
              :password => '12345678',
              :pem      => 'REDME'
            }
          }
        }
        @data = {
          'card' => { }
        }
      end
      context 'environment variables' do
        it 'should assign ActiveMerchant to testing mode' do
          @form[:config][:checkout][:test] = true
          
          @gateway = Object.new
          mock(ActiveMerchant::Billing::PayWayGateway).new(anything) { @gateway }
          stub(@gateway).purchase(@order.price, anything, nil) { true }
        
          @checkout = FormCheckout.new(@form, @page)
          @checkout.create
        
          ActiveMerchant::Billing::Base.mode.should === :test
        end
      end
    end
    
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