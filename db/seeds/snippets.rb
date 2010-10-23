#---------------------------------------------------#
# CartOverview Snippet
#---------------------------------------------------#
overview = Snippet.new
overview.name = 'CartOverview'
overview.content = <<-CONTENT
<r:shop:cart:if_cart:items:if_items>
  <dl id="cart_overview">
    <dt class="price">Price</dt>
    <dd class="price"><r:price /></dd>
    <dt class="total">Quantity</dt>
    <dd class="total"><r:quantity /></dd>
    <dt><a href="/cart" title="View Cart">View Cart</a></dt>
  </dl>
</r:shop:cart:if_cart:items:if_items>
CONTENT
overview.save

#---------------------------------------------------#
# Cart Snippet
#---------------------------------------------------#
cart = Snippet.new
cart.name = 'Cart'
cart.content = <<-CONTENT
<r:shop:cart>
  <ol id="cart">
    <r:items:each:item>
      <li class="item">
        <span class="quantity"><r:quantity /></span>
        <span class="price"><r:price /></span>
        <span class="name"><r:name /></span>
      </li>
    </r:items:each:item>
  </ol>
  <a href="/cart/address" title="Checkout">Checkout</a>
</r:shop:cart>
CONTENT
cart.save