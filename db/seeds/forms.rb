puts "Seed Shop Forms";

# Add Cart Item

Form.create({
  :title  => 'CartAddProduct',
  :action => '/shop/cart', # Redirects to the cart listing
  :body   => <<-BODY
<r:shop:product>
  <input type="hidden" name="line_item[item_id]" value="<r:id />" />
  <input type="hidden" name="line_item[item_type]" value="ShopProduct" />
  
  <input type="hidden" name="line_item[quantity]" value="1" />
  <input type="submit" name="add_to_cart" id="add_to_cart_<r:id />" value="Buy Now" />
</r:shop:product>
BODY
})

Form.create({
  :title  => 'CartAddProductVariant',
  :action => '/shop/cart', # Redirects to the cart listing
  :body   => <<-BODY
<r:shop:product>
  <input type="hidden" name="line_item[item_id]" value="<r:id />" />
  <input type="hidden" name="line_item[item_type]" value="ShopProduct" />
  
  <input type="hidden" name="line_item[quantity]" value="1" />
  <input type="submit" name="add_to_cart" id="add_to_cart_<r:id />" value="Buy Now" />
</r:shop:product>
BODY
})

# Update Cart Item

Form.create({
  :title  => 'CartUpdateItem',
  :action => '',
  :body   => <<-BODY
<r:shop:cart>
  <r:item>
    <input type="hidden" name="_method" value="put" />
    <input type="hidden" name="line_item[id]" value="<r:item:id />" />
    
    <input type="text" name="line_item[quantity]" value="<r:quantity />" />
    <input type="submit" name="add_to_cart" id="update_<r:id />" value="Update" />
  </r:item>
</r:shop:cart>
BODY
})

# Checkout Addresses

addresses_body = <<-BODY
<r:shop:cart>
  <div class="addresses">
    <div id="billing" class="address">
      <h4>Billing</h4>
      <ol class="address">
        <r:address type='billing'>
          <r:if_address><input type="hidden" name="billing[id]" value="<r:id />" /></r:if_address>
          <li>
            <r:label for='billing[name]'>Full Name</r:label>
            <input type="text" name="billing[name]" value="<r:name/>" />
          </li>
          <li>
            <r:label for='billing[email]'>Email</r:label>
            <input type="text" name="billing[email]" value="<r:email/>" />
          </li>
          <li>
            <r:label for='billing[street]'>Street</r:label>
            <input type="text" name="billing[street]" value="<r:street/>" />
          </li>
          <li>
            <r:label for='billing[city]'>Suburb and Postcode</r:label>
            <input type="text" name="billing[city]" value="<r:city/>" />
            <input type="text" name="billing[postcode]" value="<r:postcode/>" />
          </li>
          <li>
            <r:label for='billing[state]'>State and Country</r:label>
            <input type="text" name="billing[state]" value="<r:state/>" />
            <input type="text" name="billing[country]" value="<r:country/>" />
          </li>
        </r:address>
      </ol>
    </div>
    
    <div id="shipping" class="address">
      <h4>Shipping</h4>
      <ol class="address">
        <r:address type='shipping'>
          <r:if_address><input type="hidden" name="shipping[id]" value="<r:id />" /></r:if_address>
          <li>
            <r:label for='shipping[name]'>Full Name</r:label>
            <input type="text" name="shipping[name]" value="<r:name/>" />
          </li>
          <li>
            <r:label for='shipping[email]'>Email</r:label>
            <input type="text" name="shipping[email]" value="<r:email/>" />
          </li>
          <li>
            <r:label for='shipping[street]'>Street</r:label>
            <input type="text" name="shipping[street]" value="<r:street/>" />
          </li>
          <li>
            <r:label for='shipping[city]'>Suburb and Postcode</r:label>
            <input type="text" name="shipping[city]" value="<r:city/>" />
            <input type="text" name="shipping[postcode]" value="<r:postcode/>" />
          </li>
          <li>
            <r:label for='shipping[state]'>State and Country</r:label>
            <input type="text" name="shipping[state]" value="<r:state/>" />
            <input type="text" name="shipping[country]" value="<r:country/>" />
          </li>
        </r:address>
      </ol>
    </div>
  </div>
</r:shop:cart>

<r:submit value="Save Addresses" />
BODY

addresses_config = <<-CONFIG
checkout:
  address:
    billing: true
    shipping: true
CONFIG

Forms.create({
  :title        => 'CheckoutAddresses',
  :redirect_to  => '/shop',
  :body         => addresses_body,
  :config       => addresses_config
})

eway_body = <<-BODY
<r:shop:cart>
  <ol class="card">
    <li>
      <r:label for='card[type]'>Type of Card</r:label>
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
      <r:select:card:month />
      <r:select:card:year />
    </li>
  </ol>
</r:shop:cart>

<h3>Special Instructions</h3>

<p><textarea name="order[message]"></textarea></p>

<r:shop:cart:address type='billing'>
  <input type="hidden" name="options[address][address1]" value="<r:street />" />
  <input type="hidden" name="options[address][city]" value="<r:city />" />
  <input type="hidden" name="options[address][state]" value="<r:state />" />
  <input type="hidden" name="options[address][country]" value="<r:country />" />
  <input type="hidden" name="options[address][zip]" value="<r:postcode />" />
  <input type="hidden" name="options[email]" value="<r:email />" />
  <input type="hidden" name="options[description]" value="<r:config:setting key='site.url' /> order #<r:shop:cart:id />" />
</r:shop:cart:address>

<r:submit value="Place Order" />

<r:snippet name='PaymentResponse' />
BODY

eway_config = <<-CONFIG

CONFIG