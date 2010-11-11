require File.dirname(__FILE__) + "/../../../spec_helper"

#
# Test for Shop Line Item Tags
#
describe Shop::Tags::Card do
  
  dataset :pages
  
  before :all do
    @page = pages(:home)
  end
  
  it 'should describe these tags' do
    Shop::Tags::Card.tags.sort.should == [
      'form:card',
      'form:card:type',
      'form:card:month',
      'form:card:year'].sort
  end
  
  describe 'form:card:type' do
    context 'all cards' do
      it 'should output the card types' do
        tag = %{<r:form:card:type />}
        exp = %{<select name="card[type]" id="card_type">
<option value="amex">American Express</option>
<option value="diners">Diners Club</option>
<option value="mastercard">Master Card</option>
<option value="visa">Visa</option>
</select>}

        @page.should render(tag).as(exp)
      end
    end
    
    context 'except amex and diners' do
      it 'should output all except amex and diners' do
        tag = %{<r:form:card:type except="amex,diners" />}
        exp = %{<select name="card[type]" id="card_type">
<option value="mastercard">Master Card</option>
<option value="visa">Visa</option>
</select>}

        @page.should render(tag).as(exp)
      end
    end
    
    context 'only amex and diners' do
      it 'should output all except amex' do
        tag = %{<r:form:card:type only="amex,diners" />}
        exp = %{<select name="card[type]" id="card_type">
<option value="amex">American Express</option>
<option value="diners">Diners Club</option>
</select>}

        @page.should render(tag).as(exp)
      end
    end
  end
  
  describe 'form:card:month' do
    it 'should output the card months' do
      tag = %{<r:form:card:month />}
      exp = %{<select name="card[month]" id="card_month">
<option value="01">01 - January</option>
<option value="02">02 - February</option>
<option value="03">03 - March</option>
<option value="04">04 - April</option>
<option value="05">05 - May</option>
<option value="06">06 - June</option>
<option value="07">07 - July</option>
<option value="08">08 - August</option>
<option value="09">09 - September</option>
<option value="10">10 - October</option>
<option value="11">11 - November</option>
<option value="12">12 - December</option>
</select>}

      @page.should render(tag).as(exp)
    end
  end
  
  describe 'form:card:year' do
    it 'should output the card years' do
      tag = %{<r:form:card:year />}
      exp = %{<select name="card[year]" id="card_year">\n}
      (Time.new.year ... Time.new.year + 10).each do |year|
        exp << %{<option value="#{year}">#{year}</option>\n}
      end
      exp << %{</select>}
      @page.should render(tag).as(exp)
    end
  end
  
end