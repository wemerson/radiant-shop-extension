class CreateForms < ActiveRecord::Migration
  def self.up
    # Will only create a layout if it doesn't exist
    Form.create({
      :title  => 'AddToCart',
      :action => '/shop/cart/items',
      :body   => <<-CONTENT
<r:shop>
  <r:product>
    <input type="hidden" name="shop_line_item[product_id]" value="<r:id />" />
      <!-- Your Customisation Here -->
      <p>Add <r:form:text name='shop_line_item[quantity]' /> <r:name /></p>
      <!-- Your Customisation Here -->    
    <input type="submit" name="add_to_cart" id="add_to_cart_<r:id />" value="Add To Cart" />
  </r:product>
</r:shop>
CONTENT
    })
  end

  def self.down
  end
end