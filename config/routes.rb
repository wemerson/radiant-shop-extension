ActionController::Routing::Routes.draw do |map|
  
  map.namespace :admin do |admin|
    admin.namespace :shop, :member => { :remove => :get } do |shop|
      
      shop.resources :categories, :collection => { :sort => :put }, :member => { :products => :get } do |category|
        category.resources :products, :only => :new
      end
      
      shop.resources :products, :except => :new, :collection => { :sort => :put } do |product|
        product.resources :images, :controller => 'products/images', :collection => { :sort => :put }, :only => [ :index, :create, :destroy]
      end
      
      shop.resources :customers
      shop.resources :orders
    end

    admin.resources :shops, :as => 'shop', :only => [ :index ]
  end
  
  # Maps the following routes within a prefix scope of either the configured shop.url_prefix or shop
  shop_prefix = Radiant::Config['shop.url_prefix'].blank? ? 'shop' : Radiant::Config['shop.url_prefix']
  map.with_options(:path_prefix => shop_prefix) do |prefix|
    prefix.namespace :shop do |shop|
      shop.product_search   'search.:format',                   :controller => 'products',   :action => 'index', :conditions => { :method => :post }
      shop.product_search   'search/:query.:format',            :controller => 'products',   :action => 'index', :conditions => { :method => :get }
      shop.shop_categories  'categories.:format',               :controller => 'categories', :action => 'index', :conditions => { :method => :get }
      shop.shop_product     ':category_handle/:handle.:format', :controller => 'products',   :action => 'show',  :conditions => { :method => :get }
      shop.shop_category    ':handle.:format',                  :controller => 'categories', :action => 'show',  :conditions => { :method => :get }
      shop.cart             'cart',                             :controller => 'cart',       :action => 'show',  :conditions => { :method => :get }
    
      shop.with_options :path_prefix => "#{shop_prefix}/cart" do |cart|
        cart.resources :line_items, :as => :items
      end
    end
  end
  
end
