ActionController::Routing::Routes.draw do |map|
  map.namespace 'shop' do |shop|
    shop.cart 'cart', :controller => 'orders', :action => 'show', :id => 'current'
    shop.cart_items 'cart/items.:format', :controller => 'line_items', :action => 'index', :order_id => 'current', :conditions => { :method => :get } 
    shop.cart_item_add 'cart/items.:format', :controller => 'line_items', :action => 'create', :conditions => { :method => :post } 
    shop.cart_item_update 'cart/items/:id.:format', :controller => 'line_items', :action => 'update', :order_id => 'current', :conditions => { :method => :put } 
    shop.cart_item_remove 'cart/items/:id/remove.:format', :controller => 'line_items', :action => 'destroy', :order_id => 'current'
    shop.resources :orders do |orders|
      orders.resources :line_items
    end
  end
end
