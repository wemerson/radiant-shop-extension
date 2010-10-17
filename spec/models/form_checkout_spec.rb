require 'spec/spec_helper'

describe FormCheckout do

  dataset :shop_orders, :pages, :forms, :shop_addresses
  
  before :each do
    mock_page_with_request_and_data
  end
  describe '#create' do
    context 'gateway' do
      context 'order has no billing' do
        before :each do
          login_as :customer
          @order = shop_orders(:empty)
          mock_valid_form_checkout_request
        end
        
        it 'should return the standard response' do
          @checkout = FormCheckout.new(@form, @page, @form[:extensions][:bogus_checkout])
          result = @checkout.create
                    
          result[:gateway].should be_nil
          result[:payment].should be_nil
          result[:card].should    be_nil
          result[:message].should be_nil
        end
      end
      
      context 'configured correctly' do
        before :each do
          login_as :customer
          @order = shop_orders(:several_items)
          
          mock_valid_form_checkout_request
        end
        
        it 'should assign ActiveMerchant to testing mode' do
          @checkout = FormCheckout.new(@form, @page, @form[:extensions][:bogus_checkout])
          @checkout.create
          
          ActiveMerchant::Billing::Base.mode.should === :test
        end
        
        it 'should return true for payment results' do
          mock.instance_of(ActiveMerchant::Billing::CreditCard).valid? { true }
          @checkout = FormCheckout.new(@form, @page, @form[:extensions][:bogus_checkout])
          result = @checkout.create
          
          result[:gateway].should === true
          result[:card].should    === true
          result[:payment].should === true
        end
        
        it 'should assign a payment object' do
          mock.instance_of(ActiveMerchant::Billing::CreditCard).valid? { true }
          @checkout = FormCheckout.new(@form, @page, @form[:extensions][:bogus_checkout])
          result = @checkout.create
          
          @order.payment.card_number.should === "XXXX-XXXX-XXXX-1"
          @order.payment.card_type.should   === @data[:card][:type]
          @order.payment.amount.should      === @order.price
        end
        
        it 'should assign session shop_order to nil' do
          mock.instance_of(ActiveMerchant::Billing::CreditCard).valid? { true }
          @checkout = FormCheckout.new(@form, @page, @form[:extensions][:bogus_checkout])
          result = @checkout.create
        end
      end
      
      context 'configured incorrectly' do
        before :each do
          login_as :customer
          @order = shop_orders(:several_items)
          
          mock_valid_form_checkout_request
        end
        context 'no gateway' do
          it 'should return gateway false' do
            @form[:extensions][:bogus_checkout][:gateway] = nil
            
            @checkout = FormCheckout.new(@form, @page, @form[:extensions][:bogus_checkout])
            result = @checkout.create
            
            result[:gateway].should === false
            result[:card].should    be_nil
            result[:payment].should be_nil
            
            @order.payment.should be_nil
          end
        end
        
        context 'no card' do
          it 'should return card and payment false' do
            @data[:card] = nil
            
            @checkout = FormCheckout.new(@form, @page, @form[:extensions][:bogus_checkout])
            result = @checkout.create
            
            result[:gateway].should === true
            result[:card].should    be_nil
            result[:payment].should be_nil
            
            @order.payment.should be_nil
          end
        end
        
        context 'invalid card' do
          it 'should return card and payment false' do
            mock.instance_of(ActiveMerchant::Billing::CreditCard).valid? { false }
            
            @checkout = FormCheckout.new(@form, @page, @form[:extensions][:bogus_checkout])
            result = @checkout.create
            
            result[:gateway].should === true
            result[:card].should    === false
            result[:payment].should be_nil
            
            @order.payment.should be_nil
          end
        end
      end
    end
    
    context 'mail' do
      before :each do
        mock.instance_of(ActiveMerchant::Billing::CreditCard).valid? { true }
      end
      
      context 'mail configured' do
        before :each do
          login_as :customer
          @order = shop_orders(:several_items)
          
          mock_valid_form_checkout_request
        end
        context 'payment successful' do
          before :each do
            @checkout = FormCheckout.new(@form,@page,@form[:extensions][:bogus_checkout])
          end
          it 'should configure order to be sent' do
            pending 'assers called'
            
            @config = @form[:extensions][:bogus_checkout][:extensions][:order]
            
            mock(FormMail).new(@form,@page,@config) {  }
            
            @checkout.create
          end
          it 'should configure invoice to be sent with custom to' do
            pending 'assers called'
            
            @config = @form[:extensions][:bogus_checkout][:extensions][:invoice]
            @config[:extensions][:bogus_checkout][:extensions][:invoice].merge!({
              :to => @order.billing.email
            })
            
            mock(FormMail).new(@form,@page,@config) {  }
            
            @checkout.create
          end
        end
        
        context 'payment unsuccesful' do
          it 'should not configure mail to be sent' do
            @checkout = FormCheckout.new(@form, @page, @form[:extensions][:bogus_checkout])
            stub(@checkout).success? { false }
            @checkout.create
            
            @form[:extensions][:mail].should be_nil
          end
        end
      end
      
      context 'mail not configured' do
        before :each do
          login_as :customer
          @order = shop_orders(:several_items)
          
          mock_valid_form_checkout_request
          @form[:extensions][:bogus_checkout][:extensions] = nil
        end
        it 'should not configure mail to be sent' do
          @checkout = FormCheckout.new(@form, @page, @form[:extensions][:bogus_checkout])
          result = @checkout.create
          
          do_not_allow(FormMail).new(@form,@page,anything)
        end
      end
    end
  end
end