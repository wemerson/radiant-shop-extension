require 'spec/spec_helper'

describe Shop::Tags::Category do
  
  dataset :pages

  before(:each) do
    category = Object.new
    stub(category).id { 1 }
    
    @shop_category = category
    @shop_categories = [ category, category, category ]
    
    product = Object.new
    stub(product).id { 1 }
    
    @shop_product   = product
    @shop_products  = [ product, product, product ]
  end
  
  describe '<r:shop:if_categories>' do
    context 'success' do
      it 'should render' do
        mock(Shop::Tags::Helpers).current_categories(anything) { @shop_categories }
        
        tag = %{<r:shop:if_categories>success</r:shop:if_categories>}
        expected = %{success}

        pages(:home).should render(tag).as(expected)
      end
    end
    context 'failure' do
      it 'should not render' do
        mock(Shop::Tags::Helpers).current_categories(anything) { [] }
        
        tag = %{<r:shop:if_categories>failure</r:shop:if_categories>}
        expected = %{}
        pages(:home).should render(tag).as(expected)
      end
    end
  end
  
  describe '<r:shop:unless_categories>' do
    context 'success' do
      it 'should render' do
        mock(Shop::Tags::Helpers).current_categories(anything) { [] }
        
        tag = %{<r:shop:unless_categories>success</r:shop:unless_categories>}
        expected = %{success}
        pages(:home).should render(tag).as(expected)
      end
    end
    context 'failure' do
      it 'should not render' do
        mock(Shop::Tags::Helpers).current_categories(anything) { @shop_products }
        
        tag = %{<r:shop:unless_categories>failure</r:shop:unless_categories>}
        expected = %{}
        pages(:home).should render(tag).as(expected)
      end
    end
  end
  
  describe '<r:shop:categories>' do
    it 'should render' do
      tag = %{<r:shop:categories>success</r:shop:categories>}
      expected = %{success}
      
      pages(:home).should render(tag).as(expected)
    end
  end
  
  describe '<r:shop:category:if_current>' do
    before :each do
      mock(Shop::Tags::Helpers).current_category(anything) { @shop_category }
      stub(@shop_category).id { 1 }
      stub(@shop_category).handle { 'handle' }
    end
    context 'generated page' do
      it 'should expand' do
        page = pages(:home)
        stub(page).slug { @shop_category.handle }
        
        tag = %{<r:shop:category:if_current>success</r:shop:category:if_current>}
        expected =  %{success}
        
        page.should render(tag).as(expected)
      end
    end
    context 'custom page' do
      it 'should expand' do
        page = pages(:home)
        stub(page).shop_category_id { @shop_category.id }
        
        tag = %{<r:shop:category:if_current>success</r:shop:category:if_current>}
        expected =  %{success}
        
        page.should render(tag).as(expected)
      end
    end
    context 'product page' do
      it 'should expand' do
        mock(Shop::Tags::Helpers).current_product(anything) { @shop_product }
        stub(@shop_product).category { @shop_category }
        
        tag = %{<r:shop:product><r:category:if_current>success</r:category:if_current></r:shop:product>}
        expected =  %{success}
        
        pages(:home).should render(tag).as(expected)
      end
    end
    context 'failure' do
      it 'should not expand' do
        tag = %{<r:shop:category:if_current>failure</r:shop:category:if_current>}
        expected =  %{}
        
        pages(:home).should render(tag).as(expected)
      end
    end
  end
  
  describe 'simple attributes' do
    before :each do
      mock(Shop::Tags::Helpers).current_category(anything) { @shop_category }
    end
    it 'should render <r:id />' do
      stub(@shop_category).id { 1 }
      
      tag = %{<r:shop:category:id />}
      expected = %{1}
      pages(:home).should render(tag).as(expected)
    end
    it 'should render <r:name />' do
      stub(@shop_category).name { 'name' }
      
      tag = %{<r:shop:category:name />}
      expected = %{name}
      pages(:home).should render(tag).as(expected)
    end
    it 'should render <r:handle />' do
      stub(@shop_category).handle { 'handle' }
      
      tag = %{<r:shop:category:handle />}
      expected = %{handle}
      pages(:home).should render(tag).as(expected)
    end
    it 'should render <r:slug />' do
      stub(@shop_category).slug { 'slug' }
      
      tag = %{<r:shop:category:slug />}
      expected = %{slug}
      pages(:home).should render(tag).as(expected)
    end
  end
  
  describe '<r:description />' do
    it 'should render a textile filtered result' do
      mock(Shop::Tags::Helpers).current_category(anything) { @shop_category }
      stub(@shop_category).description { '*bold*' }
      
      tag = %{<r:shop:category:description />}
      expected = %{<p><strong>bold</strong></p>}
      pages(:home).should render(tag).as(expected)
    end
  end
  
  describe '<r:link />' do
    before :each do
      mock(Shop::Tags::Helpers).current_category(anything) { @shop_category }
    end
    
    context 'standalone' do
      before :each do          
        stub(@shop_category).slug { 'slug' }
        stub(@shop_category).name { 'name' }
      end
      it 'should render an anchor element' do
        tag = %{<r:shop:category:link />}
        expected = %{<a href="slug">name</a>}
        pages(:home).should render(tag).as(expected)
      end
      it 'should assign attributes' do
        tag = %{<r:shop:category:link title="title" data-title="data-title"/>}
        expected = %{<a href="slug" data-title="data-title" title="title">name</a>}
        pages(:home).should render(tag).as(expected)          
      end
    end
    
    context 'wrapped' do
      it 'should render an anchor element' do
        stub(@shop_category).slug { 'slug' }
        
        tag = %{<r:shop:category:link>title</r:shop:category:link>}
        expected = %{<a href="slug">title</a>}
        pages(:home).should render(tag).as(expected)
      end
    end
  end
  
end