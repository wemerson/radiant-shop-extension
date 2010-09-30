require 'spec/spec_helper'

describe Shop::Tags::Variant do
  
  dataset :pages, :shop_variants, :shop_products
  
  it 'should describe these tags' do
    Shop::Tags::Variant.tags.sort.should == [
      'shop:product:variants',
      'shop:product:variants:each',
      'shop:product:variants:if_variants',
      'shop:product:variants:unless_variants',
      'shop:product:variant',
      'shop:product:variant:name',
      'shop:product:variant:price',
      'shop:product:variant:link',
      'shop:product:variant:sku'].sort
  end
  
  before :all do
    @page = pages(:home)
  end
  
  context 'responses' do
    
    
    before :each do
      @product = shop_products(:crusty_bread)
      mock(Shop::Tags::Helpers).current_product(anything) { @product }
    end
    
    describe '<r:shop:product:variants>' do
      context 'variants exist' do
        it 'should render' do
          tag = %{<r:shop:product:variants>success</r:shop:product:variants>}
          exp = %{success}

          @page.should render(tag).as(exp)
        end
      end
      
      context 'variants do not exist' do
        before :each do
          @product.variants = []
        end
        it 'should render' do
          tag = %{<r:shop:product:variants>success</r:shop:product:variants>}
          exp = %{success}

          @page.should render(tag).as(exp)
        end
      end
    end
  end
  
end