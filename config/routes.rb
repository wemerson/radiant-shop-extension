ActionController::Routing::Routes.draw do |map|
  
  map.namespace :admin do |admin|
    admin.namespace :shop, :member => { :remove => :get } do |shop|
      
      shop.resources :categories, :collection => { :sort => :put }, :member => { :products => :get } do |category|
        category.resources :products, :only => :new
      end
      
      shop.resources :products, :except => :new, :collection => { :sort => :put } do |product|
        product.resources :images, :controller => 'products/images', :collection => { :sort => :put }
      end
      
      shop.resources :customers
      shop.resources :orders
    end

    admin.resources :shops, :as => 'shop', :only => [ :index ]
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
  
  # Maps the following routes within a prefix scope of either the configured shop.url_prefix or shop
  map.with_options(:path_prefix => Radiant::Config['shop.url_prefix'].blank? ? 'shop' : Radiant::Config['shop.url_prefix']) do |prefix|
    prefix.product_search   'search.:format',                   :controller => 'shop/products',   :action => 'index', :conditions => { :method => :post }
    prefix.product_search   'search/:query.:format',            :controller => 'shop/products',   :action => 'index', :conditions => { :method => :get }
    prefix.shop_categories  'categories.:format',               :controller => 'shop/categories', :action => 'index', :conditions => { :method => :get }
    prefix.shop_product     ':category_handle/:handle.:format', :controller => 'shop/products',   :action => 'show',  :conditions => { :method => :get }
    prefix.shop_category    ':handle.:format',                  :controller => 'shop/categories', :action => 'show',  :conditions => { :method => :get }
  end

end
