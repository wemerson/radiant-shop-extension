class Admin::Shop::CustomersController < Admin::ResourceController
  model_class ShopCustomer
  layout 'admin'
  active_scaffold :shop_customer
end
