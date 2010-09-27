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