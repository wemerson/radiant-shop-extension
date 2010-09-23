require 'spec/spec_helper'

#
# Tests for shop address tags
#
describe Shop::Tags::Address do
  
  dataset :pages, :shop_addresses, :shop_orders
  
  it 'should describe these tags' do
    Shop::Tags::Address.tags.sort.should == [
      'shop:cart:address',
      'shop:cart:address:if_address',
      'shop:cart:address:unless_address',
      'shop:cart:address:id',
      'shop:cart:address:name',
      'shop:cart:address:email',
      'shop:cart:address:unit',
      'shop:cart:address:street',
      'shop:cart:address:city',
      'shop:cart:address:state',
      'shop:cart:address:country',
      'shop:cart:address:postcode',
    ].sort
  end
  
  context 'inside cart' do
    before :all do
      @page = pages(:home)
    end
    
    before :each do
      @order = shop_orders(:one_item)
      @billing = shop_addresses(:billing)
      mock(Shop::Tags::Helpers).current_order(anything) { @order }
    end
  
    describe 'shop:cart:address:if_address' do
      context 'success' do
        before :each do
          mock(Shop::Tags::Helpers).current_address(anything) { @billing }
        end
        it 'should expand' do
          tag = %{<r:shop:cart:address type='billing'><r:if_address>success</r:if_address></r:shop:cart:address>}
          exp = %{success}
        
          @page.should render(tag).as(exp)
        end
      end
      context 'failure' do
        before :each do
          mock(Shop::Tags::Helpers).current_address(anything) { nil }
        end
        it 'should not expand' do
          tag = %{<r:shop:cart:address type='billing'><r:if_address>failure</r:if_address></r:shop:cart:address>}
          exp = %{}
        
          @page.should render(tag).as(exp)        
        end
      end
    end
  
    describe 'shop:cart:address:unless_address' do
      context 'success' do
        before :each do
          mock(Shop::Tags::Helpers).current_address(anything) { @billing }
        end
        it 'should expand' do
          stub(@order).billing { @billing }
        
          tag = %{<r:shop:cart:address type='billing'><r:unless_address>failure</r:unless_address></r:shop:cart:address>}
          exp = %{}
        
          @page.should render(tag).as(exp)
        end
      end
      context 'failure' do
        before :each do
          mock(Shop::Tags::Helpers).current_address(anything) { nil }
        end
        it 'should not expand' do
          stub(@order).billing { nil }
        
          tag = %{<r:shop:cart:address type='billing'><r:unless_address>success</r:unless_address></r:shop:cart:address>}
          exp = %{success}
        
          @page.should render(tag).as(exp)        
        end
      end
    end

    describe 'shop:address' do
      context 'no address' do
        before :each do
          mock(Shop::Tags::Helpers).current_address(anything) { @billing }
        end
        it 'should expand' do
          tag = %{<r:shop:cart:address type='billing'>success</r:shop:cart:address>}
          exp = %{success}
      
          @page.should render(tag).as(exp)
        end
      end
      context 'address' do
        before :each do
          mock(Shop::Tags::Helpers).current_address(anything) { nil }
        end
        it 'should expand' do
          tag = %{<r:shop:cart:address type='billing'>success</r:shop:cart:address>}
          exp = %{success}
      
          @page.should render(tag).as(exp)
        end
      end
    end
  
    describe 'attributes' do
      before :each do
        mock(Shop::Tags::Helpers).current_address(anything) { @billing }
      end
      context 'shop:cart:address:id' do
        it 'should return the id' do
          tag = %{<r:shop:cart:address type='billing'><r:id /></r:shop:cart:address>}
          exp = @billing.id.to_s
        
          @page.should render(tag).as(exp)
        end
      end
      context 'shop:cart:address:name' do
        it 'should return the name' do
          tag = %{<r:shop:cart:address type='billing'><r:name /></r:shop:cart:address>}
          exp = @billing.name
        
          @page.should render(tag).as(exp)
        end
      end
      context 'shop:cart:address:email' do
        it 'should return the email' do
          tag = %{<r:shop:cart:address type='billing'><r:email /></r:shop:cart:address>}
          exp = @billing.email
        
          @page.should render(tag).as(exp)
        end
      end
      context 'shop:cart:address:unit' do
        it 'should return the unit' do
          tag = %{<r:shop:cart:address type='billing'><r:unit /></r:shop:cart:address>}
          exp = @billing.unit
        
          @page.should render(tag).as(exp)
        end
      end
      context 'shop:cart:address:street' do
        it 'should return the street' do
          tag = %{<r:shop:cart:address type='billing'><r:street /></r:shop:cart:address>}
          exp = @billing.street
        
          @page.should render(tag).as(exp)
        end
      end
      context 'shop:cart:address:city' do
        it 'should return the city' do
          tag = %{<r:shop:cart:address type='billing'><r:city /></r:shop:cart:address>}
          exp = @billing.city
        
          @page.should render(tag).as(exp)
        end
      end
      context 'shop:cart:address:state' do
        it 'should return the city' do
          tag = %{<r:shop:cart:address type='billing'><r:state /></r:shop:cart:address>}
          exp = @billing.state
        
          @page.should render(tag).as(exp)
        end
      end
      context 'shop:cart:address:country' do
        it 'should return the country' do
          tag = %{<r:shop:cart:address type='billing'><r:country /></r:shop:cart:address>}
          exp = @billing.country
        
          @page.should render(tag).as(exp)
        end
      end
      context 'shop:cart:address:postcode' do
        it 'should return the postcode' do
          tag = %{<r:shop:cart:address type='billing'><r:postcode /></r:shop:cart:address>}
          exp = @billing.postcode
        
          @page.should render(tag).as(exp)
        end
      end
    end
  end
  
end