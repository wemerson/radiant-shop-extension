require 'spec/spec_helper'

describe Shop::Tags::Responses do
  
  dataset :forms, :pages
  
  context 'contained tags' do
  
    it 'should describe these tags' do
      Shop::Tags::Responses.tags.sort.should == [
        'response:if_results', 
        'response:unless_results',
        'response:if_get', 
        'response:unless_get',      
      ].sort
    end
    
  end
  
  context 'conditionals' do
    
    before :each do
      @page = pages(:home)
      mock_response
    end
    
    describe 'if_results' do
      context 'extension sent results' do
        it 'should render' do
          @response.result[:results] = { :bogus => { :payment => true } }
          
          tag = %{<r:response:if_results extension='bogus'>success</r:response:if_results>}
          exp = %{success}
          @page.should render(tag).as(exp)
        end
      end
      context 'extension did not send results' do
        it 'should not render' do
          tag = %{<r:response:if_results extension='bogus'>failure</r:response:if_results>}
          exp = %{}
          @page.should render(tag).as(exp)
        end
      end
    end
    
    describe 'unless_results' do
      context 'extension did not send results' do
        it 'should render' do
          tag = %{<r:response:unless_results extension='bogus'>success</r:response:unless_results>}
          exp = %{success}
          @page.should render(tag).as(exp)
        end
      end
      context 'extension sent results' do
        it 'should not render' do
          @response.result[:results] = { :bogus => { :payment => true } }
          
          tag = %{<r:response:unless_results extension='bogus'>failure</r:response:unless_results>}
          exp = %{}
          @page.should render(tag).as(exp)
        end
      end
    end
    
    describe 'if_get' do
      context 'extension sent positive results' do
        it 'should render' do
          @response.result[:results] = { :bogus => { :payment => true } }
          
          tag = %{<r:response:if_results extension='bogus'><r:if_get name='payment'>success</r:if_get></r:response:if_results>}
          exp = %{success}
          @page.should render(tag).as(exp)
        end
      end
      context 'extension sent negative results' do
        it 'should not render' do
          @response.result[:results] = { :bogus => { :payment => false } }
          
          tag = %{<r:response:if_results extension='bogus'><r:if_get name='payment'>failure</r:if_get></r:response:if_results>}
          exp = %{}
          @page.should render(tag).as(exp)
        end
      end
    end
    
    describe 'unless_get' do
      context 'extension sent positive results' do
        it 'should render' do
          @response.result[:results] = { :bogus => { :payment => false } }
          
          tag = %{<r:response:if_results extension='bogus'><r:unless_get name='payment'>success</r:unless_get></r:response:if_results>}
          exp = %{success}
          @page.should render(tag).as(exp)
        end
      end
      context 'extension sent negative results' do
        it 'should not render' do
          @response.result[:results] = { :bogus => { :payment => true } }
          
          tag = %{<r:response:if_results extension='bogus'><r:unless_get name='payment'>failure</r:unless_get></r:response:if_results>}
          exp = %{}
          @page.should render(tag).as(exp)
        end
      end
    end
    
  end

end