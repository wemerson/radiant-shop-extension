require 'spec/spec_helper'

describe Shop::Tags::Product do
  
  dataset :pages
  
  it 'should describe these tags' do
    Shop::Tags::Product.tags.sort.should == [
      'shop:if_products',
      'shop:unless_products',
      'shop:products',
      'shop:products:each',
      'shop:product',
      'shop:product:id',
      'shop:product:name',
      'shop:product:price',
      'shop:product:sku',
      'shop:product:slug',
      'shop:product:description',
      'shop:product:link',
      'shop:product:if_images',
      'shop:product:unless_images',
      'shop:product:images',
      'shop:product:images:each'].sort
  end

  before(:each) do
    product = Object.new
    stub(product).id { 1 }
    
    @shop_product   = product
    @shop_products  = [ product, product, product ]
    
    image = Object.new
    stub(image).id { 1 }
    
    @image = image
    @images = [ image, image, image ]
  end
  
  describe '<r:shop:if_products>' do
    context 'success' do
      it 'should render' do
        mock(Shop::Tags::Helpers).current_products(anything) { @shop_products }
        
        tag = %{<r:shop:if_products>success</r:shop:if_products>}
        expected = %{success}
        pages(:home).should render(tag).as(expected)
      end
    end
    context 'failure' do
      it 'should not render' do
        mock(Shop::Tags::Helpers).current_products(anything) { [] }
        
        tag = %{<r:shop:if_products>failure</r:shop:if_products>}
        expected = %{}
        pages(:home).should render(tag).as(expected)
      end
    end
  end
  
  describe '<r:shop:unless_products>' do
    context 'success' do
      it 'should render' do
        mock(Shop::Tags::Helpers).current_products(anything) { [] }
        
        tag = %{<r:shop:unless_products>success</r:shop:unless_products>}
        expected = %{success}
        pages(:home).should render(tag).as(expected)
      end
    end
    context 'failure' do
      it 'should not render' do
        mock(Shop::Tags::Helpers).current_products(anything) { @shop_products }
        
        tag = %{<r:shop:unless_products>failure</r:shop:unless_products>}
        expected = %{}
        pages(:home).should render(tag).as(expected)
      end
    end
  end
  
  describe '<r:shop:products>' do
    it 'should render' do
      tag = %{<r:shop:products>success</r:shop:products>}
      expected = %{success}
      
      pages(:home).should render(tag).as(expected)
    end
  end
  
  describe '<r:shop:products:each>' do
    context 'success' do
      it 'should not render' do
        mock(Shop::Tags::Helpers).current_products(anything) { @shop_products }
        
        tag = %{<r:shop:products:each>.a.</r:shop:products:each>}
        expected = %{.a..a..a.}
        pages(:home).should render(tag).as(expected)
      end      
    end
    context 'failure' do
      it 'should not render' do
        mock(Shop::Tags::Helpers).current_products(anything) { [] }
        
        tag = %{<r:shop:products:each>failure</r:shop:products:each>}
        expected = %{}
        pages(:home).should render(tag).as(expected)
      end
    end
  end
  
  describe '<r:shop:product>' do
    context 'success' do
      it 'should render' do
        mock(Shop::Tags::Helpers).current_product(anything) { @shop_product }
        
        tag = %{<r:shop:product>success</r:shop:product>}
        expected = %{success}
        pages(:home).should render(tag).as(expected)
      end
    end
    context 'failure' do
      it 'should not render' do
        mock(Shop::Tags::Helpers).current_product(anything) { nil }

        tag = %{<r:shop:product>failure</r:shop:product>}
        expected = %{}
        pages(:home).should render(tag).as(expected)
      end
    end
    
    describe 'simple attributes' do
      before :each do
        mock(Shop::Tags::Helpers).current_product(anything) { @shop_product }
      end
      it 'should render <r:id />' do
        stub(@shop_product).id { 1 }
        
        tag = %{<r:shop:product:id />}
        expected = %{1}
        pages(:home).should render(tag).as(expected)
      end
      it 'should render <r:name />' do
        stub(@shop_product).name { 'name' }
        
        tag = %{<r:shop:product:name />}
        expected = %{name}
        pages(:home).should render(tag).as(expected)
      end
      it 'should render <r:sku />' do
        stub(@shop_product).sku { 'sku' }
        
        tag = %{<r:shop:product:sku />}
        expected = %{sku}
        pages(:home).should render(tag).as(expected)
      end
      it 'should render <r:slug />' do
        stub(@shop_product).slug { 'slug' }
        
        tag = %{<r:shop:product:slug />}
        expected = %{slug}
        pages(:home).should render(tag).as(expected)
      end
    end
    
    describe '<r:description />' do
      it 'should render a textile filtered result' do
        mock(Shop::Tags::Helpers).current_product(anything) { @shop_product }
        stub(@shop_product).description { '*bold*' }
        
        tag = %{<r:shop:product:description />}
        expected = %{<p><strong>bold</strong></p>}
        pages(:home).should render(tag).as(expected)
      end
    end
    
    describe '<r:link />' do
      before :each do
        mock(Shop::Tags::Helpers).current_product(anything) { @shop_product }
      end
      
      context 'standalone' do
        before :each do          
          stub(@shop_product).slug { 'slug' }
          stub(@shop_product).name { 'name' }
        end
        it 'should render an anchor element' do
          tag = %{<r:shop:product:link />}
          expected = %{<a href="slug">name</a>}
          pages(:home).should render(tag).as(expected)
        end
        it 'should assign attributes' do
          tag = %{<r:shop:product:link title="title" data-title="data-title"/>}
          expected = %{<a href="slug" data-title="data-title" title="title">name</a>}
          pages(:home).should render(tag).as(expected)          
        end
      end
      
      context 'wrapped' do
        it 'should render an anchor element' do
          stub(@shop_product).slug { 'slug' }
          
          tag = %{<r:shop:product:link>title</r:shop:product:link>}
          expected = %{<a href="slug">title</a>}
          pages(:home).should render(tag).as(expected)
        end
      end
    end
    
    describe '<r:price />' do
      before :each do
        mock(Shop::Tags::Helpers).current_product(anything) { @shop_product }
        stub(@shop_product).price { 1234.34567890 }
      end
      
      it 'should render a standard price' do
        tag = %{<r:shop:product:price />}
        expected = %{$1,234.35}
        pages(:home).should render(tag).as(expected)
      end
      
      it 'should render a high precision price' do
        tag = %{<r:shop:product:price precision="8"/>}
        expected = %{$1,234.34567890}
        pages(:home).should render(tag).as(expected)
      end
      
      it 'should render a custom format' do
        tag = %{<r:shop:product:price unit="%" separator="-" delimiter="+" />}
        expected = %{%1+234-35}
        pages(:home).should render(tag).as(expected)
      end
    end
    
    describe '<r:shop:product:if_images>' do
      before :each do
        mock(Shop::Tags::Helpers).current_product(anything) { @shop_product }
      end
      
      context 'success' do
        it 'should render' do
          stub(@shop_product).images { @images }

          tag = %{<r:shop:product:if_images>success</r:shop:product:if_images>}
          expected = %{success}
          pages(:home).should render(tag).as(expected)
        end
      end
      
      context 'failure' do
        it 'should not render' do
          stub(@shop_product).images { [] }

          tag = %{<r:shop:product:if_images>failure</r:shop:product:if_images>}
          expected = %{}
          pages(:home).should render(tag).as(expected)
        end
      end
    end

    describe '<r:shop:product:unless_images>' do
      before :each do
        mock(Shop::Tags::Helpers).current_product(anything) { @shop_product }
      end
      
      context 'success' do
        it 'should render' do
          stub(@shop_product).images { [] }
          
          tag = %{<r:shop:product:unless_images>success</r:shop:product:unless_images>}
          expected = %{success}
          pages(:home).should render(tag).as(expected)
        end
      end
      
      context 'failure' do
        it 'should not render' do
          stub(@shop_product).images { @images }

          tag = %{<r:shop:product:unless_images>failure</r:shop:product:unless_images>}
          expected = %{}
          pages(:home).should render(tag).as(expected)
        end
      end
    end
    
    describe '<r:shop:product:images>' do
      before :each do
        mock(Shop::Tags::Helpers).current_product(anything) { @shop_product }
      end
      it 'should render' do
        tag = %{<r:shop:product:images>success</r:shop:product:images>}
        expected = %{success}

        pages(:home).should render(tag).as(expected)
      end
    end
    
    describe '<r:shop:product:images:each>' do
      before :each do
        mock(Shop::Tags::Helpers).current_product(anything) { @shop_product }
      end
      context 'success' do
        before :each do
          stub(@shop_product).images { @images }
        end
        it 'should not render' do
          tag = %{<r:shop:product:images:each>.a.</r:shop:product:images:each>}
          expected = %{.a..a..a.}
          
          pages(:home).should render(tag).as(expected)
        end
        it 'should assign the local image' do
          tag = %{<r:shop:product:images:each><r:image:id /></r:shop:product:images:each>}
          expected = %{111}

          pages(:home).should render(tag).as(expected)
        end    
      end
      context 'failure' do
        it 'should not render' do
          stub(@shop_product).images { [] }
          
          tag = %{<r:shop:product:images:each>failure</r:shop:product:images:each>}
          expected = %{}
          pages(:home).should render(tag).as(expected)
        end
      end
    end
    
  end
  
end
