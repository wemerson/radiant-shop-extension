#---------------------------------------------------#
# Add Cart Item
#---------------------------------------------------#
add = Form.new
add.title = 'CartAddProduct'
add.body  = <<-BODY
<r:shop:product>
  <input type="hidden" name="line_item[item_id]" value="<r:id />" />
  <input type="hidden" name="line_item[item_type]" value="ShopProduct" />
  
  <input type="hidden" name="line_item[quantity]" value="1" />
  <input type="submit" name="add_to_cart" id="add_to_cart_<r:id />" value="Buy Now" />
</r:shop:product>
BODY
add.config = <<-CONFIG
add_product:
  extension: line_item
  process:   add
CONFIG

add.save

#---------------------------------------------------#
# Update Cart Item
#---------------------------------------------------#
update = Form.new
update.title = 'CartUpdateItem'
update.body  = <<-BODY
<r:shop:cart>
<r:item>
  <input type="hidden" name="_method" value="put" />
  <input type="hidden" name="line_item[id]" value="<r:item:id />" />
  
  <input type="text" name="line_item[quantity]" value="<r:quantity />" />
  <input type="submit" name="add_to_cart" id="update_<r:id />" value="Update" />
</r:item>
</r:shop:cart>
BODY
update.config = <<-CONFIG
add_product:
  extension: line_item
  process:   modify
CONFIG

update.save

#---------------------------------------------------#
# Checkout Addresses
#---------------------------------------------------#
addresses = Form.new
addresses.title = 'CheckoutAddresses'
addresses.redirect_to = '/shop/checkout/payment'
addresses.body  = <<-BODY
<r:shop:cart>
  <div class="addresses">
    <div id="billing" class="address">
      <h4>Billing</h4>
      <ol class="address">
        <r:address type='billing'>
          <r:if_address><input type="hidden" name="billing[id]" value="<r:id />" /></r:if_address>
          <li class="billing_name_input">
            <r:label for='billing[name]'>Full Name</r:label>
            <input type="text" name="billing[name]" value="<r:name/>" />
          </li>
          <li class="billing_email_input">
            <r:label for='billing[email]'>Email</r:label>
            <input type="text" name="billing[email]" value="<r:email/>" />
          </li>
          <li class="billing_street_input">
            <r:label for='billing[street]'>Street</r:label>
            <input type="text" name="billing[street]" value="<r:street/>" />
          </li>
          <li class="billing_city_input">
            <r:label for='billing[city]'>Suburb and Postcode</r:label>
            <input type="text" name="billing[city]" value="<r:city/>" />
            <input type="text" name="billing[postcode]" value="<r:postcode/>" />
          </li>
          <li class="billing_state_input">
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
          <li class="shipping_name_input">
            <r:label for='shipping[name]'>Full Name</r:label>
            <input type="text" name="shipping[name]" value="<r:name/>" />
          </li>
          <li class="shipping_email_input">
            <r:label for='shipping[email]'>Email</r:label>
            <input type="text" name="shipping[email]" value="<r:email/>" />
          </li>
          <li class="shipping_street_input">
            <r:label for='shipping[street]'>Street</r:label>
            <input type="text" name="shipping[street]" value="<r:street/>" />
          </li>
          <li class="shipping_city_input">
            <r:label for='shipping[city]'>Suburb and Postcode</r:label>
            <input type="text" name="shipping[city]" value="<r:city/>" />
            <input type="text" name="shipping[postcode]" value="<r:postcode/>" />
          </li>
          <li class="shipping_state_input">
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
addresses.config = <<-CONFIG
checkout_addresses:
  extension: address
  billing: true
  shipping: true
CONFIG

addresses.save