unless Page.first
  Radiant::Config['defaults.page.status'] = 'Published'
  
  home = Page.new
  home.title = 'Shop'
  home.slug = '/'
  home.breadcrumb = 'shop'
  home.class_name = 'ShopPage'
  home.status_id = 100
  home.parts = [
    PagePart.create({ 
      :name      => 'body', 
      :filter_id => 'Textile',
      :content   => <<-CONTENT
"category":/category

"product":/category/product
CONTENT
    })
  ]
  home.save
  debugger
end

Radiant::Config['shop.root_page_id'] = Page.first.id

category = ShopCategory.create({
  :page_attributes => { 
    :title     => 'Category', 
    :slug      => 'category', 
    :parent    => Page.first, 
    :layout    => Layout.find_by_name(Radiant::Config['shop.layout_category']),
    :status_id => 100
  }
})

product = ShopProduct.create({ 
  :price       => 10.00,
  :page_attributes => { 
    :title     => 'Product', 
    :parent    => category.page, 
    :slug      => 'product', 
    :layout    => Layout.find_by_name(Radiant::Config['shop.layout_product']),
    :status_id => 100
  }
})

