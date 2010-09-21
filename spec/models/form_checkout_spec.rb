require 'spec/spec_helper'

describe FormCheckout do

  dataset :shop_orders, :pages, :forms
  
  describe '#initialize' do
    it 'should assign the instance variables' do
      @form = forms(:checkout)
      @page = pages(:home)
      @order = shop_orders(:one_item)
    end
  end
  
  describe '#process' do
    it 'should accept a payment method'

    it 'should set status' do
      context 'success' do
        it 'should set status to success'
      end
      context 'failure' do
        it 'should set status to failed'
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