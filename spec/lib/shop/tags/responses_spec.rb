require 'spec/spec_helper'

describe Shop::Tags::Responses do
  
  dataset :forms, :pages
  
  it 'should describe these tags' do
    Shop::Tags::Responses.tags.sort.should == [
      'response:checkout',
      'response:checkout:payment',
      'response:checkout:payment:if_success',
      'response:checkout:payment:unless_success'
    ].sort
  end
  
  context 'responses' do
    
    before :each do
      mock_page_with_request_and_data
      mock_response
      
      @checkout = valid_form_checkout_request_and_response
    end
    
    describe '<r:response:checkout>' do
      context 'checkout exists' do
        before :each do
          @response.result[:results][:checkout] = @checkout.create
        end
        it 'should expand' do
          tag = %{<r:response:checkout>success</r:response:checkout>}
          exp = %{success}
          
          pages(:home).should render(tag).as(exp)
        end
      end
      context 'checkout does not exist' do
        it 'should not expand' do
          tag = %{<r:response:checkout>failure</r:response:checkout>}
          exp = %{}
        
          pages(:home).should render(tag).as(exp)
        end
      end
    end
    
    describe '<r:response:payment>' do
      before :each do
        @response.result[:results][:checkout] = @checkout.create
      end
      context 'payment success' do
        it 'should expand' do
          tag = %{<r:response:checkout:payment>success</r:response:checkout:payment>}
          exp = %{success}
        
          pages(:home).should render(tag).as(exp)
        end
      end
      context 'payment failure' do
        before :each do
          @response.result[:results][:checkout][:payment] = false
        end
        it 'should expand' do
          tag = %{<r:response:checkout:payment>success</r:response:checkout:payment>}
          exp = %{success}
          
          pages(:home).should render(tag).as(exp)
        end
      end
    end
    
    describe '<r:response:payment:if_success>' do
      before :each do
        @response.result[:results][:checkout] = @checkout.create
      end
      context 'payment success' do
        it 'should expand' do
          tag = %{<r:response:checkout:payment:if_success>success</r:response:checkout:payment:if_success>}
          exp = %{success}
          
          pages(:home).should render(tag).as(exp)
        end
      end
      context 'payment failure' do
        before :each do
          @response.result[:results][:checkout][:payment] = false
        end
        it 'should not expand' do
          tag = %{<r:response:checkout:payment:if_success>failure</r:response:checkout:payment:if_success>}
          exp = %{}
          
          pages(:home).should render(tag).as(exp)
        end
      end
    end
    
  end

end