Snippet.create({
  :name     => 'CartOverview',
  :content  => <<-BEGIN
<r:shop:cart>
  <r:if_items>
    <span class="quantity"><r:quantity /></span>
    <span class="price"><r:price /></span>
    <r:link>checkout</r:link>
  </r:if_items>
  <r:unless_items>
    <p>Your cart is empty</p>
  </r:unless_items>
</r:shop:cart>
BEGIN
})

PaymentResponse

<r:response:checkout:payment:unless_success>
  <p>We couldn't process your payment: <strong><r:response:get name="results[checkout][payment][message]" /></strong></p>
</r:response:checkout:payment:unless_success>

<r:response:clear />