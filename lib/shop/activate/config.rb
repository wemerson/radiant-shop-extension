module Shop
  module Activate
    module Tags
      Radiant::Config['shop.layout_product']  ||= 'Product'
      Radiant::Config['shop.layout_category'] ||= 'Products'
      
      Radiant::Config['shop.price_unit']      ||= '$'
      Radiant::Config['shop.price_precision'] ||= 2
      Radiant::Config['shop.price_separator'] ||= '.'
      Radiant::Config['shop.price_delimiter'] ||= ','
      
      Radiant::Config['shop.tax_strategy']    ||= 'inclusive'
      Radiant::Config['shop.tax_percentage']  ||= '10'
      Radiant::Config['shop.tax_name']        ||= 'gst'
      
      Radiant::Config['shop.date_format']     ||= '%d/%m/%Y'
      
      Radiant::Config['users.customer.redirect'] = '/cart'  
    end
  end
end