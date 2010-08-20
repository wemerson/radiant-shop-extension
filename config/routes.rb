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
  
end