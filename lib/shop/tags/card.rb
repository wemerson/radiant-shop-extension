module Shop
  module Tags
    module Card
      
      CARD_TYPES = {
        'visa'    => 'Visa',
        'master'  => 'Master Card',
        'diners'  => 'Diners Club',
        'amex'    => 'American Express'
      }
      
      include Radiant::Taggable
      
      tag 'form:card' do |tag|
        tag.expand
      end
      
      # Outputs a list of credit card types
      desc %{ Outputs a list of credit card types }
      tag 'form:card:type' do |tag|
        content = %{<select name="credit_card[type]" id="credit_card_type">\n}
        cards = {}
        cards.merge! CARD_TYPES
        
        cards.reject! { |k,v| tag.attr['except'].split(',').include? k } if tag.attr['except'].present?
        cards.reject! { |k,v| !tag.attr['only'].split(',').include? k  }if tag.attr['only'].present?
        
        cards.sort.each do |k, v|
          content << %{<option value="#{k}">#{v}</option>\n}
        end
        content << %{</select>}
      end
      
      # Outputs a list of months for credit cards
      desc %{ Outputs a list of months for credit cards }
      tag 'form:card:month' do |tag|
        content = %{<select name="credit_card[month]" id="credit_card_month">\n}
          Date::MONTHNAMES[1,12].each_with_index do |name,index|
            month = sprintf('%02d', index+1)
            content << %{<option value="#{month}">#{month} - #{name}</option>\n}
          end
        content << %{</select>}
      end
      
      # Ouputs a list of years for credit cards
      desc %{ Ouputs a list of years for credit cards }
      tag 'form:card:year' do |tag|
        content = %{<select name="credit_card[year]" id="credit_card_year">\n}
          (Time.new.year ... Time.new.year + 15).each do |year|
            content << %{<option value="#{year}">#{year}</option>\n}
          end
        content << %{</select>}
      end
      
    end
  end
end