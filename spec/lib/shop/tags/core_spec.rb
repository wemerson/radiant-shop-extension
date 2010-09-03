require 'spec/spec_helper'

describe Shop::Tags::Core do

  dataset :pages
  
  describe '<r:shop>' do
    it 'should render' do
      tag = %{<r:shop>success</r:shop>}
      expected = %{success}
      
      pages(:home).should render(tag).as(expected)
    end
  end
  
end