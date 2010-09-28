require 'spec/spec_helper'

describe FormCheckout do

  dataset :shop_orders, :pages, :forms, :shop_addresses
  
  before :each do
    mock_page_with_request_and_data
  end
  describe '#create' do
    context 'addresses' do
      
      context 'sending ids with user logged in' do
        before :each do
          login_as :customer # Will have existing addresses due to several_items
          @order = shop_orders(:one_item)
          mock_valid_form_checkout_request
        end
        
        context 'both billing and shipping' do
          it 'should assign that address to the order billing and shipping' do
            @data[:billing]   = { :id => shop_orders(:several_items).billing.id }
            @data[:shipping]  = { :id => shop_orders(:several_items).shipping.id }
            
            @checkout = FormCheckout.new(@form, @page)
            result = @checkout.create
            
            shop_orders(:one_item).billing.should  === shop_addresses(:billing)
            shop_orders(:one_item).shipping.should === shop_addresses(:shipping)
            
            result[:billing].should  === true
            result[:shipping].should === true
          end
        end
        
        context 'just billing' do
          it 'should assign shipping to be billing' do
            # Set the order to have no shipping address
            @data[:shipping] = {}
            
            @checkout = FormCheckout.new(@form, @page)
            result = @checkout.create
            
            shop_orders(:one_item).billing.should  === shop_addresses(:billing)
            shop_orders(:one_item).shipping.should === shop_addresses(:billing)
            
            result[:billing].should  === true
            result[:shipping].should === true
          end
        end
      end
      
      context 'sending ids without customer logged in' do
        before :each do
          @order = shop_orders(:one_item)
          mock_valid_form_checkout_request
        end
        context 'both billing and shipping' do
          it 'it should not assign those addresses' do
            @checkout = FormCheckout.new(@form, @page)
            result = @checkout.create
            
            shop_orders(:one_item).billing.should  be_nil
            shop_orders(:one_item).shipping.should be_nil
            
            result[:billing].should  === false
            result[:shipping].should === false
          end
        end
      end
      
      context 'sending ids as a bad customer' do
        before :each do
          login_as :bad_customer
          @order = shop_orders(:one_item)
          mock_valid_form_checkout_request
        end
        it 'should not assign those addresses' do
          @checkout = FormCheckout.new(@form, @page)
          result = @checkout.create
          
          shop_orders(:one_item).billing.should  be_nil
          shop_orders(:one_item).shipping.should be_nil
          
          result[:billing].should  === false
          result[:shipping].should === false
        end
      end
      
      context 'updating existing addresses' do
        before :each do
          login_as :customer
          @order = shop_orders(:several_items)
          mock_valid_form_checkout_request
        end
        it 'should keep them assigned and update them' do
          @data[:billing]   = { :name => 'new billing' }
          @data[:shipping]  = { :name => 'new shipping' }
          
          @checkout = FormCheckout.new(@form, @page)
          result = @checkout.create
          
          shop_addresses(:billing).name.should  === 'new billing'
          shop_addresses(:shipping).name.should === 'new shipping'
          
          result[:billing].should  === true
          result[:shipping].should === true
        end
      end
          
      context 'new addresses' do
        before :each do
          login_as :customer
          @order = shop_orders(:one_item)
          mock_valid_form_checkout_request
          
          @data[:billing][:id]  = nil
          @data[:shipping][:id] = nil
        end
        
        context 'both billing and shipping sent' do
          it 'should create new addresses' do            
            @checkout = FormCheckout.new(@form, @page)
            result = @checkout.create
            
            shop_orders(:one_item).billing.name.should  === @data[:billing][:name]
            shop_orders(:one_item).shipping.name.should === @data[:shipping][:name]
            
            result[:billing].should  === true
            result[:shipping].should === true
          end
        end
        
        context 'only billing sent' do
          it 'should copy billing to shipping' do
            @data[:shipping] = {}
            
            @checkout = FormCheckout.new(@form, @page)
            result = @checkout.create
            
            shop_orders(:one_item).billing.name.should  === @data[:billing][:name]
            shop_orders(:one_item).shipping.name.should === @data[:billing][:name]
            
            result[:billing].should  === true
            result[:shipping].should === true
          end
        end
        
        context 'billing sent with same shipping' do
          it 'should copy billing to shipping' do
            @data[:shipping] = @data[:billing]
            
            @checkout = FormCheckout.new(@form, @page)
            result = @checkout.create
            
            shop_orders(:one_item).shipping.should      === shop_orders(:one_item).billing
            
            result[:billing].should  === true
            result[:shipping].should === true
          end
        end
      end
    end
    
    context 'gateway' do
        context 'configured correctly' do
        before :each do
          login_as :customer
          @order = shop_orders(:one_item)
          
          mock_valid_form_checkout_request
        end
        
        it 'should assign ActiveMerchant to testing mode' do
          @checkout = FormCheckout.new(@form, @page)
          @checkout.create
          
          ActiveMerchant::Billing::Base.mode.should === :test
        end
        
        it 'should return true for payment results' do
          mock.instance_of(ActiveMerchant::Billing::CreditCard).valid? { true }
          @checkout = FormCheckout.new(@form, @page)
          result = @checkout.create
          
          result[:gateway].should === true
          result[:card].should    === true
          result[:payment].should === true
        end
        
        it 'should assign a payment object' do
          mock.instance_of(ActiveMerchant::Billing::CreditCard).valid? { true }
          @checkout = FormCheckout.new(@form, @page)
          result = @checkout.create
          
          @order.payment.card_number.should === "XXXX-XXXX-XXXX-1"
          @order.payment.card_type.should   === @data[:card][:type]
          @order.payment.amount.should      === @order.price
        end
      end
      
      context 'configured incorrectly' do
        before :each do
          login_as :customer
          @order = shop_orders(:one_item)
          
          mock_valid_form_checkout_request
        end
        context 'no gateway' do
          it 'should return gateway false' do
            mock.instance_of(ActiveMerchant::Billing::CreditCard).valid? { true }
            @form[:extensions][:checkout][:gateway] = nil
            
            @checkout = FormCheckout.new(@form, @page)
            result = @checkout.create
            
            result[:gateway].should === false
            result[:card].should    === false
            result[:payment].should === false
            
            @order.payment.should be_nil
          end
        end
        
        context 'no card' do
          it 'should return card and payment false' do
            mock.instance_of(ActiveMerchant::Billing::CreditCard).valid? { true }
            @data[:card] = nil
            
            @checkout = FormCheckout.new(@form, @page)
            result = @checkout.create
            
            result[:gateway].should === true
            result[:card].should    === false
            result[:payment].should === false
            
            @order.payment.should be_nil
          end
        end
        
        context 'invalid card' do
          it 'should return card and payment false' do
            mock.instance_of(ActiveMerchant::Billing::CreditCard).valid? { false }
            
            @checkout = FormCheckout.new(@form, @page)
            result = @checkout.create
            
            result[:gateway].should === true
            result[:card].should    === false
            result[:payment].should === false
            
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
          @order = shop_orders(:one_item)
          
          mock_valid_form_checkout_request
        end
        context 'payment successful' do
          it 'should configure mail to be sent' do
            @checkout = FormCheckout.new(@form, @page)
            @checkout.create
            
            @form[:extensions][:mail][:to].should         === shop_addresses(:billing).email
            @form[:extensions][:mail][:recipient].should  === shop_addresses(:billing).email
            @form[:extensions][:mail][:subject].should    === @form[:extensions][:checkout][:mail][:subject]
            @form[:extensions][:mail][:bcc].should        === @form[:extensions][:checkout][:mail][:bcc]
          end
        end
        
        context 'payment unsuccesful' do
          it 'should not configure mail to be sent' do
            @checkout = FormCheckout.new(@form, @page)
            stub(@checkout).success? { false }
            @checkout.create
            
            @form[:extensions][:mail].should be_nil
          end
        end
      end
      
      context 'mail not configured' do
        before :each do
          login_as :customer
          @order = shop_orders(:one_item)
          
          mock_valid_form_checkout_request
          @form[:extensions][:checkout][:mail] = nil
        end
        it 'should not configure mail to be sent' do
          @checkout = FormCheckout.new(@form, @page)
          result = @checkout.create
          
          @form[:extensions][:mail].should be_nil
        end
      end
    end
  end
end