ActionController::Routing::Routes.draw do |map|
  
  map.namespace :admin do |admin|
    admin.namespace :shop, :member => {:remove => :get } do |shop|
      shop.namespace :products do |products|
        products.resources :images
        products.resources :assets
      end
    
      shop.resources :categories, :collection => { :sort => :put } do |category|
        category.new_product 'products/new.:format', :controller => 'products', :action => 'new', :conditions => { :method => :get }
        category.products 'products.:format', :controller => 'categories', :action => 'products', :conditions => { :method => :get }
      end
      
      shop.resources :products, :collection => { :sort => :put } do |product|
        product.sort_images 'images/sort.:format', :controller => 'products/images', :action => 'sort', :conditions => { :method => :put }
        product.resources :images, :controller => 'products/images'
      end
      shop.resources :customers
      shop.resources :orders
    end
  end
  
end