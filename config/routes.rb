ActionController::Routing::Routes.draw do |map|
  
  map.namespace :admin do |admin|
    admin.namespace :shop, :member => { :remove => :get } do |shop|
      
      shop.resources :categories, :collection => { :sort => :put }, :member => { :products => :get } do |category|
        category.resources :products, :only => :new
      end
      
      shop.resources :products, :except => :new, :collection => { :sort => :put }
      
      shop.namespace :products do |product|
        product.resources :images, :collection => { :sort => :put }
      end
      
      shop.resources :customers
      shop.resources :orders
    end
  end

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
