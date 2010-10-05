require 'spec/spec_helper'

describe Shop::Tags::Category do
  
  dataset :pages, :shop_categories, :shop_products

  before :each do
    @page = pages(:home)
  end

  before(:each) do
    @category = shop_categories(:bread)
  end
  
  describe '<r:shop:if_categories>' do
    context 'success' do
      it 'should render' do
        mock(Shop::Tags::Helpers).current_categories(anything) { [@category] }
        
        tag = %{<r:shop:if_categories>success</r:shop:if_categories>}
        exp = %{success}

        @page.should render(tag).as(exp)
      end
    end
    context 'failure' do
      it 'should not render' do
        mock(Shop::Tags::Helpers).current_categories(anything) { [] }
        
        tag = %{<r:shop:if_categories>failure</r:shop:if_categories>}
        exp = %{}
        @page.should render(tag).as(exp)
      end
    end
  end
  
  describe '<r:shop:unless_categories>' do
    context 'success' do
      it 'should render' do
        mock(Shop::Tags::Helpers).current_categories(anything) { [] }
        
        tag = %{<r:shop:unless_categories>success</r:shop:unless_categories>}
        exp = %{success}
        @page.should render(tag).as(exp)
      end
    end
    context 'failure' do
      it 'should not render' do
        mock(Shop::Tags::Helpers).current_categories(anything) { [@category] }
        
        tag = %{<r:shop:unless_categories>failure</r:shop:unless_categories>}
        exp = %{}
        @page.should render(tag).as(exp)
      end
    end
  end
  
  describe '<r:shop:categories>' do
    it 'should render' do
      mock(Shop::Tags::Helpers).current_categories(anything) { [@category] }
      tag = %{<r:shop:categories>success</r:shop:categories>}
      exp = %{success}
      
      @page.should render(tag).as(exp)
    end
  end
  
  describe '<r:shop:category:if_current>' do
    before :each do
      mock(Shop::Tags::Helpers).current_category(anything) { @category }
    end
    context 'generated page' do
      it 'should expand' do
        page = pages(:home)
        stub(page).slug { @category.handle }
        
        tag = %{<r:shop:category:if_current>success</r:shop:category:if_current>}
        exp =  %{success}
        
        page.should render(tag).as(exp)
      end
    end
    context 'custom page' do
      it 'should expand' do
        @page.shop_category_id = @category.id
        
        tag = %{<r:shop:category:if_current>success</r:shop:category:if_current>}
        exp =  %{success}
        
        @page.should render(tag).as(exp)
      end
    end
    context 'product page' do
      it 'should expand' do
        @page.shop_product_id = @category.products.first.id
        
        tag = %{<r:shop:product><r:category:if_current>success</r:category:if_current></r:shop:product>}
        exp =  %{success}
        
        @page.should render(tag).as(exp)
      end
    end
    context 'failure' do
      it 'should not expand' do
        tag = %{<r:shop:category:if_current>failure</r:shop:category:if_current>}
        exp =  %{}
        
        @page.should render(tag).as(exp)
      end
    end
  end
  
  describe 'simple attributes' do
    before :each do
      mock(Shop::Tags::Helpers).current_category(anything) { @category }
    end
    it 'should render <r:id />' do
      tag = %{<r:shop:category:id />}
      exp = @category.id.to_s
      
      @page.should render(tag).as(exp)
    end
    it 'should render <r:name />' do
      tag = %{<r:shop:category:name />}
      exp = @category.name
      
      @page.should render(tag).as(exp)
    end
    it 'should render <r:handle />' do
      tag = %{<r:shop:category:handle />}
      exp = @category.handle
      
      @page.should render(tag).as(exp)
    end
    it 'should render <r:slug />' do
      tag = %{<r:shop:category:slug />}
      exp = @category.slug
      
      @page.should render(tag).as(exp)
    end
  end
  
  describe '<r:description />' do
    it 'should render a textile filtered result' do
      mock(Shop::Tags::Helpers).current_category(anything) { @category }
      @category.description = '*bold*'
      
      tag = %{<r:shop:category:description />}
      exp = %{<p><strong>bold</strong></p>}
      
      @page.should render(tag).as(exp)
    end
  end
  
  describe '<r:link />' do
    before :each do
      mock(Shop::Tags::Helpers).current_category(anything) { @category }
    end
    
    context 'standalone' do
      it 'should render an anchor element' do
        tag = %{<r:shop:category:link />}
        exp = %{<a href="#{@category.slug}">#{@category.name}</a>}
        
        @page.should render(tag).as(exp)
      end
      it 'should assign attributes' do
        tag = %{<r:shop:category:link title="title" data-title="data-title"/>}
        exp = %{<a href="#{@category.slug}" data-title="data-title" title="title">#{@category.name}</a>}
        
        @page.should render(tag).as(exp)          
      end
    end
    
    context 'wrapped' do
      it 'should render an anchor element' do
        tag = %{<r:shop:category:link>title</r:shop:category:link>}
        exp = %{<a href="#{@category.slug}">title</a>}
        
        @page.should render(tag).as(exp)
      end
    end
  end
  
end