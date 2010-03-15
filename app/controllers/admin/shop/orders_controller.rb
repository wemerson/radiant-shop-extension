class Admin::Shop::OrdersController < Admin::ResourceController
  model_class ShopOrder
  layout 'admin'
  active_scaffold :shop_order
end
