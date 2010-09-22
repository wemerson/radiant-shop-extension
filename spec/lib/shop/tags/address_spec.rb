require 'spec/spec_helper'

#
# Tests for shop address tags
#
describe Shop::Tags::Address do
  
  dataset :pages, :shop_addresses, :shop_orders
  
  it 'should describe these tags' do
    Shop::Tags::Address.tags.sort.should == [
      'shop:if_address',
      'shop:unless_address',
      'shop:address',
      'shop:address:name',
      'shop:address:email',
      'shop:address:unit',
      'shop:address:street',
      'shop:address:city',
      'shop:address:country',
      'shop:address:postcode',
    ].sort
  end
  
  before :all do
    @page = pages(:home)
  end
  
  before :each do
    @order = shop_orders(:empty)
    @billing = shop_addresses(:billing)
  end
  
  describe 'shop:if_address' do
    before :each do
      mock(Shop::Tags::Helpers).current_order(anything) { @order }
    end
    context 'success' do
      it 'should expand' do
        stub(@order).billing { @billing }
        
        tag = %{<r:shop:if_address type='billing'>success</r:shop:if_address>}
        exp = %{success}
        
        @page.should render(tag).as(exp)
      end
    end
    context 'failure' do
      it 'should not expand' do
        stub(@order).billing { nil }
        
        tag = %{<r:shop:if_address type='billing'>failure</r:shop:if_address>}
        exp = %{}
        
        @page.should render(tag).as(exp)        
      end
      it 'should not expand' do
        stub(@order).billing { @billing }
        
        tag = %{<r:shop:if_address type='willing'>failure</r:shop:if_address>}
        exp = %{}
        
        @page.should render(tag).as(exp)        
      end
      it 'should not expand' do
        @order = nil
        
        tag = %{<r:shop:if_address type='billing'>failure</r:shop:if_address>}
        exp = %{}
        
        @page.should render(tag).as(exp)        
      end
    end
  end
  
  describe 'shop:unless_address' do
    before :each do
      mock(Shop::Tags::Helpers).current_order(anything) { @order }
    end
    context 'success' do
      it 'should expand' do
        stub(@order).billing { @billing }
        
        tag = %{<r:shop:unless_address type='billing'>failure</r:shop:unless_address>}
        exp = %{}
        
        @page.should render(tag).as(exp)
      end
    end
    context 'failure' do
      it 'should not expand' do
        stub(@order).billing { nil }
        
        tag = %{<r:shop:unless_address type='billing'>success</r:shop:unless_address>}
        exp = %{success}
        
        @page.should render(tag).as(exp)        
      end
      it 'should not expand' do
        stub(@order).billing { @billing }
        
        tag = %{<r:shop:unless_address type='willing'>success</r:shop:unless_address>}
        exp = %{success}
        
        @page.should render(tag).as(exp)        
      end
      it 'should not expand' do
        @order = nil
        
        tag = %{<r:shop:unless_address type='billing'>success</r:shop:unless_address>}
        exp = %{success}
        
        @page.should render(tag).as(exp)        
      end
    end
  end

  describe 'shop:address' do
    before :each do
      mock(Shop::Tags::Helpers).current_order(anything) { @order }
    end
    context 'success' do
      it 'should expand' do
        stub(@order).billing { @billing }
        
        tag = %{<r:shop:address type='billing'>success</r:shop:address>}
        exp = %{success}
        
        @page.should render(tag).as(exp)
      end
    end
    context 'failure' do
      it 'should not expand' do
        stub(@order).billing { nil }
        
        tag = %{<r:shop:address type='billing'>failure</r:shop:address>}
        exp = %{}
        
        @page.should render(tag).as(exp)
      end
    end
  end
  
  describe 'attributes' do
    before :each do
      mock(Shop::Tags::Helpers).current_address(anything) { @billing }
    end
    context 'shop:address:name' do
      it 'should return the name' do
        tag = %{<r:shop:address type='billing'><r:name /></r:shop:address>}
        exp = @billing.name
        
        @page.should render(tag).as(exp)
      end
    end
    context 'shop:address:email' do
      it 'should return the email' do
        tag = %{<r:shop:address type='billing'><r:email /></r:shop:address>}
        exp = @billing.email
        
        @page.should render(tag).as(exp)
      end
    end
    context 'shop:address:unit' do
      it 'should return the unit' do
        tag = %{<r:shop:address type='billing'><r:unit /></r:shop:address>}
        exp = @billing.unit
        
        @page.should render(tag).as(exp)
      end
    end
    context 'shop:address:street' do
      it 'should return the street' do
        tag = %{<r:shop:address type='billing'><r:street /></r:shop:address>}
        exp = @billing.street
        
        @page.should render(tag).as(exp)
      end
    end
    context 'shop:address:city' do
      it 'should return the city' do
        tag = %{<r:shop:address type='billing'><r:city /></r:shop:address>}
        exp = @billing.city
        
        @page.should render(tag).as(exp)
      end
    end
    context 'shop:address:country' do
      it 'should return the country' do
        tag = %{<r:shop:address type='billing'><r:country /></r:shop:address>}
        exp = @billing.country
        
        @page.should render(tag).as(exp)
      end
    end
    context 'shop:address:postcode' do
      it 'should return the postcode' do
        tag = %{<r:shop:address type='billing'><r:postcode /></r:shop:address>}
        exp = @billing.postcode
        
        @page.should render(tag).as(exp)
      end
    end
  end
  
end