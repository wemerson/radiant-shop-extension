class Admin::Shop::GroupsController < Admin::ResourceController
  model_class ShopGroup

  before_filter :config_global
  before_filter :config_index,  :only => [ :index ]
  before_filter :config_new,    :only => [ :new, :create ]
  before_filter :config_edit,   :only => [ :edit, :update ]
  before_filter :assets_global
  before_filter :assets_index,  :only => [ :index ]
  before_filter :assets_edit,   :only => [ :edit, :update ]
  
  private
  
    def config_global
      @inputs   ||= []
      @meta     ||= []
      @buttons  ||= []
      @parts    ||= []
      @popups   ||= []
      
      @inputs   << 'name'
      @parts    << 'description'
    end
    
    def config_index
      @buttons  << 'variant_templates'
      @buttons  << 'product_groups'
    end
    
    def config_new
    end
    
    def config_edit
      @parts    << 'products'
      
      @buttons  << 'browse_products'
      
      @popups   << 'browse_products'
    end
    
    def assets_global
    end
    
    def assets_index
      include_stylesheet 'admin/extensions/shop/index'
    end
    
    def assets_edit
      include_stylesheet 'admin/extensions/shop/edit'
      include_javascript 'admin/extensions/shop/edit'
      
      include_stylesheet 'admin/extensions/shop/groups/edit'
      include_javascript 'admin/extensions/shop/groups/edit'
    end
    
end
