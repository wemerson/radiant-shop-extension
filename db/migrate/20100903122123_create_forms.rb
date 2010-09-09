class CreateForms < ActiveRecord::Migration
  def self.up
    # Will only create a layout if it doesn't exist
    Form.create({
      :title  => 'AddCartItem',
      :action => '/shop/cart/items',
      :body   => <<-CONTENT
<r:shop>
  <r:product>
    <input type="hidden" name="line_item[item_id]" value="<r:id />" />
    <!-- Your Customisation Below -->
    
    <r:form:text name='line_item[quantity]' /> <!-- Amount of items to add -->
    <input type="submit" name="add_to_cart" id="add_to_cart_<r:id />" value="Add To Cart" />
    
    <!-- Your Customisation Above -->
  </r:product>
</r:shop>
CONTENT
    })
    
    Form.create({
      :title  => 'UpdateCartItem',
      :action => '/shop/cart/items/x',
      :body   => <<-CONTENT
<r:shop:cart>
  <r:item>
    <input type="hidden" name="_method" value="put" />
    <input type="hidden" name="line_item[id]" value="<r:item:id />" />
    <!-- Your Customisation Below -->
    
    <input type="text" name="line_item[quantity]" value="" />
    <input type="submit" name="add_to_cart" id="update_<r:id />" value="Update" />
    
    <!-- Your Customisation Above -->
  </r:item>
</r:shop:cart>
CONTENT
    })
  end

  def self.down
  end
end