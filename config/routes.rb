ActionController::Routing::Routes.draw do |map|
  
  map.namespace :admin do |admin|
    admin.namespace :shop, :member => { :remove => :get } do |shop|      
      shop.resources :categories, :collection => { :sort => :put }, :member => { :products => :get } do |category|
        category.resources :products, :only => :new
      end
      
      shop.resources :products, :except => :new, :collection => { :sort => :put } do |product|
        product.resources :images,            :controller => 'products/images',             :only => [:index, :create, :destroy],   :collection => { :sort => :put }
        product.resources :variants,          :controller => 'products/variants',           :only => [ :create, :destroy]
        product.resources :variant_templates, :controller => 'products/variant_templates',  :only => [ :update ]
        product.resources :discounts,         :controller => 'products/discounts',          :only => [ :create, :destroy]
        product.resources :discount_templates,:controller => 'products/discount_templates', :only => [ :update ]
      end
      
      shop.resources :packages, :member => { :remove => :get } do |packages|
        packages.resources :packings,         :controller => 'packages/packings',           :only => [:create, :update, :destroy],  :collection => { :sort => :put }
      end
      
      shop.resources :discounts
      
      shop.resources :variants
      
      shop.resources :customers
      
      shop.resources :orders
    end

    admin.resources :shops, :as => 'shop', :only => [ :index ]
  end
  
end
