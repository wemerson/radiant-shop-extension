#---------------------------------------------------#
# Product Layout
#---------------------------------------------------#
product = Layout.new
product.name = Radiant::Config['shop.layout_product']
product.content = <<-CONTENT
<!DOCTYPE html>
<html>
  <r:shop:product>
    <head>
      <title>Product - <r:name /></title>
    </head>
    <body>  
      <div id="product_<r:slug />" class="product" data-id="<r:id />">
        <h2><r:title /></h2>
        <h3><r:price /></h3>
        <dl id="product_details">
          <dt class="description">Description</dt>
          <dd class="description"><r:description /></dd>
          <dt class="add_product">Add To Cart</dt>
          <dd class="add_product"><r:form name="CartAddProduct" /></dd>
        </dl>
        <r:images:if_images>
          <ul id="product_images">
            <r:each:image style='preview'>
              <li class="product_image" id="product_image_<r:position />">
                <img src="<r:url />" alt="<r:title />" />
              </li>
            </r:each:image>
          </ul>
        </r:images:if_images>
      </div>
    </body>
  </r:shop:product>
</html>
CONTENT
product.save

#---------------------------------------------------#
# Category Layout
#---------------------------------------------------#
category = Layout.new
category.name = Radiant::Config['shop.layout_category']
category.content = <<-CONTENT
<!DOCTYPE html>
<html>
  <r:shop:category>
    <head>
      <title>Product - <r:name /></title>
    </head>
    <body>
      <div id="category_<r:slug />" class="category" data-id="<r:id />">
        <h2><r:title /></h2>
        <dl id="description_details">
          <dt class="description">Description</dt>
          <dd class="description"><r:description /></dd>
        </div>
        <r:products>
          <r:if_products>
            <ul class="category_products">
              <r:each:product>
                <li class="product" id="product_<r:sku />" data-id="<r:id />">
                  <r:image position='1'>
                    <img src="<r:url />" alt="<r:title />" />
                  </r:image>
                  <h3><r:link /></h3>
                  <h4><r:price /></h4>
                </li>
              </r:each:product>
            </ul>
          </r:if_products>
          <r:unless_products>
            <p class="error" id="shop_no_products_error">We don't have any products available here yet.</p>
          </r:unless_products>
        </r:products>
      </div>
    </body>
  </r:shop:category>
</html>
CONTENT
category.save