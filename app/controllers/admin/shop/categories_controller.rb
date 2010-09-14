class Admin::Shop::CategoriesController < Admin::ResourceController
  
  model_class ShopCategory
  
  before_filter :config_global
  before_filter :config_new,    :only => [ :new, :create ]
  before_filter :config_edit,   :only => [ :edit, :update ]
  before_filter :assets_global
  
  # GET /admin/shop/products/categories
  # GET /admin/shop/products/categories.js
  # GET /admin/shop/products/categories.json                      AJAX and HTML
  #----------------------------------------------------------------------------
  def index
    @shop_categories = ShopCategory.search(params[:search])
    
    attr_hash = {
      :include  => { :products => { :only => ShopProduct.params } },
      :only     => ShopCategory.params
    }
    
    respond_to do |format|
      format.html { redirect_to admin_shop_products_path }
      format.js   { render :partial => '/admin/shop/categories/category', :collection => @shop_categories }
      format.json { render :json    => @shop_categories.to_json(attr_hash) }
    end
  end
  
  # GET /admin/shop/products/categories/1/products
  # GET /admin/shop/products/categories/1/products.js
  # GET /admin/shop/products/categories/1/products.json           AJAX and HTML
  #----------------------------------------------------------------------------
  def products
    @shop_category = ShopCategory.find(params[:id])
    @shop_products = @shop_category.products
    
    attr_hash = {
      :only     => ShopProduct.params
    }
    
    respond_to do |format|
      format.html { render :template  => '/admin/shop/products/index' }
      format.js   { render :partial   => '/admin/shop/products/product', :collection => @shop_products }
      format.json { render :json      => @shop_products.to_json(attr_hash) }
    end
  end
  
  # PUT /admin/shop/categories/sort
  # PUT /admin/shop/categories/sort.js
  # PUT /admin/shop/categories/sort.json                          AJAX and HTML
  #----------------------------------------------------------------------------
  def sort
    notice  = 'Categories successfully sorted.'
    error   = 'Could not sort Categories.'
    
    begin  
      @shop_categories = CGI::parse(params[:categories])["shop_categories[]"]

      @shop_categories.each_with_index do |id, index|
        ShopCategory.find(id).update_attribute(:position, index+1)
      end
      
      respond_to do |format|
        format.html {
          flash[:notice] = notice
          redirect_to admin_shop_products_path
        }
        format.js   { render  :text => notice, :status => :ok }
        format.json { render  :json => { :notice => notice }, :status => :ok }
      end
    rescue
      respond_to do |format|
        format.html {
          flash[:error] = error
          redirect_to admin_shop_products_path
        }
        format.js   { render  :text => error, :status => :unprocessable_entity }
        format.json { render  :json => { :error => error }, :status => :unprocessable_entity }
      end
    end
  end
  
  # POST /admin/shop/products/categories
  # POST /admin/shop/products/categories.js
  # POST /admin/shop/products/categories.json                     AJAX and HTML
  #----------------------------------------------------------------------------
  def create
    notice = 'Category created successfully.'
    error = 'Could not create Category.'
    attr_hash = ShopCategory.params
    
    begin
      @shop_category = ShopCategory.create!(params[:shop_category])
      
      respond_to do |format|
        format.html { 
          flash[:notice] = notice
          
          redirect_to edit_admin_shop_category_path(@shop_category) if params[:continue]
          redirect_to admin_shop_categories_path unless params[:continue]
        }
        format.js   { render :partial => '/admin/shop/categories/category', :locals => { :product => @shop_category } }
        format.json { render :json    => @shop_category.to_json(attr_hash) }
      end
    rescue
      respond_to do |format|
        format.html { 
          flash[:error] = error
          render :new
        }
        format.js   { render :text  => error, :status => :unprocessable_entity }
        format.json { render :json  => { :error => error }, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/shop/products/categories/1
  # PUT /admin/shop/products/categories/1.js
  # PUT /admin/shop/products/categories/1.json                    AJAX and HTML
  #----------------------------------------------------------------------------
  def update
    notice = 'Category updated successfully.'
    error = 'Could not update Category.'
    attr_hash = ShopCategory.params
    
    begin
      @shop_category.update_attributes!(params[:shop_category])
      
      respond_to do |format|
        format.html { 
          flash[:notice] = notice
          redirect_to edit_admin_shop_category_path(@shop_category) if params[:continue]
          redirect_to admin_shop_categories_path unless params[:continue]
        }
        format.js   { render :partial => '/admin/shop/categories/category', :locals => { :product => @shop_category } }
        format.json { render :json    => @shop_category.to_json(attr_hash) }
      end
    rescue
      respond_to do |format|
        format.html { 
          flash[:error] = error
          render :edit
        }
        format.js   { render :text  => error, :status => :unprocessable_entity }
        format.json { render :json  => { :error => error }, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/shop/products/categories/1
  # DELETE /admin/shop/products/categories/1.js
  # DELETE /admin/shop/products/categories/1.json                 AJAX and HTML
  #----------------------------------------------------------------------------
  def destroy
    notice = 'Category deleted successfully.'
    error = 'Could not delete Category.'
    
    begin
      @shop_category.destroy
      
      respond_to do |format|
        format.html {
          flash[:notice] = notice
          redirect_to admin_shop_categories_path
        }
        format.js   { render :text  => notice, :status => :ok }
        format.json { render :json  => { :notice => notice }, :status => :ok }
      end
    rescue
      respond_to do |format|
        format.html {
          flash[:error] = error
          render :remove
        }
        format.js   { render :text  => error, :status => :unprocessable_entity }
        format.json { render :json  => { :error => error }, :status => :unprocessable_entity }
      end
    end
  end
  
private

  def config_global
    @meta     ||= []
    @buttons  ||= []
    @parts    ||= []
  end

  def config_new
    @meta  << 'layouts'
    @meta  << 'handle'
    @parts << { :title => 'description' }
  end

  def config_edit
    @meta  << 'layouts'
    @meta  << 'handle'
    @parts << { :title => 'description' }
  end

  def assets_global
    include_stylesheet 'admin/extensions/shop/forms'
  end
  
end