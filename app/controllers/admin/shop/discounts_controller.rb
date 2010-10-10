class Admin::Shop::DiscountsController < Admin::ResourceController
  
  model_class ShopDiscount

  before_filter :config_global
  before_filter :config_index,  :only => [ :index ]
  before_filter :config_new,    :only => [ :new, :create ]
  before_filter :config_edit,   :only => [ :edit, :update ]
  before_filter :assets_global, :except => [ :remove, :destroy ]
  
  private
  
    def config_global
      @inputs   ||= []
      @meta     ||= []
      @buttons  ||= []
      @parts    ||= []
      @popups   ||= []
    end
    
    def config_index
      @buttons  << 'packages'
      @buttons  << 'variants'
      @buttons  << 'discounts'
    end
    
    def config_new
      @inputs   << 'name'
      @inputs   << 'amount'
      @inputs   << 'code'
      
      @meta     << 'start'
      @meta     << 'end'
      
      @parts    << 'categories'
    end
    
    def config_edit
      @inputs   << 'name'
      @inputs   << 'amount'
      @inputs   << 'code'
      
      @meta     << 'start'
      @meta     << 'end'
      
      @parts    << 'categories'
    end
    
    def assets_global
      include_stylesheet 'admin/extensions/shop/edit'
      include_stylesheet 'admin/extensions/shop/index'
    end
    
end