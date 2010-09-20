class FormsDataset < Dataset::Base
  def load
    create_record :form, :checkout, 
      :title    => 'Checkout',
      :body     => <<-BODY
<r:shop:cart>
  <ul class="items">
    <r:items:each:item>
      <li class="item"><r:quantity /> x <r:name /></li>
    </r:items:each:item>
  </ul>
  <div class="addresses">
    <ol class="billing">
      <li>
        <r:label for='billing[name]'>Name</r:label>
        <r:text name='billing[name]' />
      </li>
      <li>
        <r:label for='billing[unit]'>Unit</r:label>
        <r:text name='billing[unit]' />
      </li>
      <li>
        <r:label for='billing[street]'>Street</r:label>
        <r:text name='billing[street]' />
      </li>
      <li>
        <r:label for='billing[suburb]'>Suburb</r:label>
        <r:text name='billing[suburb]' />
      </li>
      <li>
        <r:label for='billing[state]'>State</r:label>
        <r:text name='billing[state]' />
      </li>
      <li>
        <r:label for='billing[postcode]'>Postcode</r:label>
        <r:text name='billing[postcode]' />
      </li>
      <li>
        <r:label for='billing[country]'>Country</r:label>
        <r:text name='billing[country]' />
      </li>
    </ol>
    <ol class="shipping">
      <li>
        <r:label for='shipping[name]'>Name</r:label>
        <r:text name='shipping[name]' />
      </li>
      <li>
        <r:label for='shipping[unit]'>Unit</r:label>
        <r:text name='shipping[unit]' />
      </li>
      <li>
        <r:label for='shipping[street]'>Street</r:label>
        <r:text name='shipping[street]' />
      </li>
      <li>
        <r:label for='shipping[suburb]'>Suburb</r:label>
        <r:text name='shipping[suburb]' />
      </li>
      <li>
        <r:label for='shipping[state]'>State</r:label>
        <r:text name='shipping[state]' />
      </li>
      <li>
        <r:label for='shipping[postcode]'>Postcode</r:label>
        <r:text name='shipping[postcode]' />
      </li>
      <li>
        <r:label for='shipping[country]'>Country</r:label>
        <r:text name='shipping[country]' />
      </li>
    </ol>
  </div>
  <ol class="card">
    <li>
      <r:label for='card[type]'>Type Card</r:label>
      <r:select name='card[type]'>
        <r:option value='visa'>Visa</r:option>
        <r:option value='mastercard'>Master Card</r:option>
        <r:option value='diners'>Diners Club</r:option>
        <r:option vlaue='amex'>AMEX</r:option>
      </r:select>
    </li>
    <li>
      <r:label for='card[name]'>Name on Card</r:label>
      <r:text name='card[name]' />
    </li>
    <li>
      <r:label for='card[number]'>Card Number</r:label>
      <r:text name='card[number]' />
    </li>
    <li>
      <r:label for='card[verification]'>Verification Code</r:label>
      <r:text name='card[verification]' length='4' />
    </li>
    <li>
      <r:label for='card[month]'>Date on Card</r:label>
      # Todo turns these into tags
      <r:select name='card[month]'>
        <r:option value='01'>01 - January</r:option>
        <r:option value='02'>02 - February</r:option>
        <r:option value='03'>03 - March</r:option>
        <r:option value='04'>04 - April</r:option>
        <r:option value='05'>05 - May</r:option>
        <r:option value='06'>06 - June</r:option>
        <r:option value='07'>07 - July</r:option>
        <r:option value='08'>08 - August</r:option>
        <r:option value='09'>09 - September</r:option>
        <r:option value='10'>10 - October</r:option>
        <r:option value='11'>11 - November</r:option>
        <r:option value='12'>12 - December</r:option>
      </r:select>
      <r:select name='card[year]'>
        <r:option value='2010'>2010</r:option>
        <r:option value='2011'>2011</r:option>
        <r:option value='2012'>2012</r:option>
        <r:option value='2013'>2013</r:option>
        <r:option value='2014'>2014</r:option>
      </r:select>
    </li>
  </ol>
  <r:form:submit />
</r:shop:cart>
BODY
      :content  => <<-CONTENT
      
CONTENT
      :config   => <<-CONFIG
checkout:
  gateway:
    name: PayWay
    username: 123456
    password: abcdef
    merchant: test
    pem: /var/www/certificate.pem
CONFIG
  end
end