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
      context 'address configured' do
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
      
      context 'not configured' do
        before :each do
          @form[:config] = {
            :checkout   => {
              :address  => {
                :enabled => true
              }
            }
          }
        end
        it 'should not call on the Address methods' do
          @addresses = ShopAddress.all
                    
          @checkout = FormCheckout.new(@form, @page)
          result = @checkout.create
          
          ShopAddress.all.should === @addresses
        end
      end
    end
    
    context 'gateway' do
      context 'merchant' do
        context 'configured' do
          before :each do
            @form[:config] = {
              :checkout   => {
                :test     => true,
                :gateway  => {
                  :name   => 'PayWay',
                  :credentials=> {
                    :username => 'abcdefgh',
                    :password => '12345678',
                    :pem      => 'README',
                    :merchant => 'test'
                  }
                }
              }
            }
            @data = {
              'card' => { }
            }
            
            @gateway = Object.new
            mock(ActiveMerchant::Billing::PayWayGateway).new(@form[:config][:checkout][:gateway][:credentials]) { @gateway }
            stub(@gateway).purchase(@order.price, anything, nil) { true }
          end
          it 'should assign ActiveMerchant to testing mode' do        
            @checkout = FormCheckout.new(@form, @page)
            @checkout.create
        
            ActiveMerchant::Billing::Base.mode.should === :test
          end
          
          it 'should return gateway true' do
            @checkout = FormCheckout.new(@form, @page)
            result = @checkout.create
            
            result[:checkout][:gateway].should === true
          end
        end
        
        context 'not configured' do
          before :each do
            @form[:config] = {
              :checkout   => {
                :test     => true
              }
            }
          end
          
          it 'should not call PayWayGateway' do
            dont_allow(ActiveMerchant::Billing::PayWayGateway).new
            
            @checkout = FormCheckout.new(@form, @page)
            @checkout.create
          end
          
          it 'should return gateway false' do
            @checkout = FormCheckout.new(@form, @page)
            result = @checkout.create
            
            result[:checkout][:gateway].should === false
          end
        end
      end
      
      context 'card' do
        before :each do
          @form[:config] = {
            :checkout   => {
              :test     => true,
              :gateway  => {
                :name   => 'PayWay',
                :credentials => {}
              }
            }
          }
          @data = {
            'card' => { 
              'number'        => 1234123412341234,
              'name'          => 'Mr. Joe Bloggs',
              'verification'  => 123,
              'month'         => 1,
              'year'          => 2009,
              'type'          => 'visa'
            }
          }
          
          @gateway = Object.new
          mock(ActiveMerchant::Billing::PayWayGateway).new(@form[:config][:checkout][:gateway][:credentials]) { @gateway }
          stub(@gateway).purchase(@order.price, anything, nil) { true }
        end
        context 'configured' do
          before :each do
            @card = Object.new
            stub(@card).valid? { true }
            
            mock(ActiveMerchant::Billing::CreditCard).new({
              :number             => 1234123412341234,
              :month              => 1,
              :year               => 2009,
              :first_name         => 'Mr. Joe',
              :last_name          => 'Bloggs',
              :verfication_value  => 123,
              :type               => 'visa'
            }) { @card }
          end
          context 'should return card details' do
            context 'valid' do
              it 'should return valid' do
                stub(@card).valid? { true }
                
                @checkout = FormCheckout.new(@form, @page)
                result = @checkout.create
                
                result[:checkout][:card][:valid].should === true
              end
            end
            context 'invalid' do
              it 'should return invalid' do
                stub(@card).valid? { false }
                
                @checkout = FormCheckout.new(@form, @page)
                result = @checkout.create
                
                result[:checkout][:card][:valid].should === false
              end
            end
          end
          it 'should return relevant details' do
            stub(@card).valid? { true }
            
            @checkout = FormCheckout.new(@form, @page)
            result = @checkout.create
            
            result[:checkout][:card].should == {
              :name   => 'Mr. Joe Bloggs',
              :month  => 1,
              :year   => 2009,
              :type   => 'visa',
              :valid  => true
            }
          end
          it 'should not return sensitive details' do
            stub(@card).valid? { true }
            
            @checkout = FormCheckout.new(@form, @page)
            result = @checkout.create
            
            result[:checkout][:card][:number].should === nil
            result[:checkout][:card][:verification].should === nil
          end
        end
      end
      
    end
  end
end