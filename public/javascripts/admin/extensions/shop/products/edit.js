var ShopProductAssets = {}

document.observe("dom:loaded", function() {
  shop = new Shop()
  shop.ProductInitialize()
  
  Event.addBehavior({
    '#browse_images_popup_close:click' : function(e) { shop.ImageClose() },
    '#new_image_popup_close:click' : function(e) { shop.ImageClose() },
    
    '#image_form:submit' : function(e) { shop.ImageSubmit() },
    
    '#browse_images_popup .image:click' : function(e) { shop.ProductImageCreate($(this)) },
    '#product_attachments .delete:click' : function(e) { shop.ProductImageDestroy($(this).up('.image')) }
  })
})

ShopProductAssets.List = Behavior.create({
  
  onclick: function() { 
    shop.ProductImageCreate(this.element)
  }
  
});

var Shop = Class.create({
  
  ProductInitialize: function() {
    if($('shop_product_id')) {
      this.ProductImagesSort()
    }
  },
  
  ProductImagesSort: function() {
    Sortable.create('product_attachments', {
      constraint: false, 
      overlap: 'horizontal',
      containment: ['product_attachments'],
      onUpdate: function(element) {
        new Ajax.Request(urlify($('sort_admin_shop_product_images_path').value), {
          method: 'put',
          parameters: {
            'product_id': $('shop_product_id').value,
            'attachments':Sortable.serialize('product_attachments')
          }
        });
      }.bind(this)
    })
  },
  
  ProductImageCreate: function(element) {
    showStatus('Adding Image...')
    element.hide()
    new Ajax.Request(urlify($('admin_shop_product_images_path').value), {
      method: 'post',
      parameters: {
        'product_id' : $('shop_product_id').value,
        'attachment[image_id]' : element.getAttribute('data-image_id')
      },
      onSuccess: function(data) {
        // Insert item into list, re-call events
        $('product_attachments').insert({ 'bottom' : data.responseText})
        shop.ProductImagesSort()
        element.remove()
        hideStatus()
      }.bind(element),
      onFailure: function() {
        element.show()
        hideStatus()
      }
    });
  },
  
  ProductImageDestroy: function(element) {
    showStatus('Removing Image...');
    element.hide();
    new Ajax.Request(urlify($('admin_shop_product_images_path').value, element.readAttribute('data-attachment_id')), { 
      method: 'delete',
      onSuccess: function(data) {
        $('images').insert({ 'bottom' : data.responseText })
        element.remove()
        hideStatus()
      }.bind(this),
      onFailure: function(data) {
        element.show();
        hideStatus();
      }.bind(this)
    });
  },
  
  ImageSubmit: function() {
    showStatus('Uploading Image...')
  },
  
  ImageClose: function() {
    Element.closePopup('new_image_popup')
    Element.closePopup('browse_images_popup')
    
    $$('.clearable').each(function(input) {
      input.value = ''
    })
  }
  
})

function urlify(route, id) {
  var url = route
  if ( id !== undefined ) {
    url += '/' + id
  }
  
  url += '.js?' + new Date().getTime()
  
  return url
}