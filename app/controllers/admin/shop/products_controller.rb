class Admin::Shop::ProductsController < Admin::ResourceController
  
  model_class ShopProduct
  
  before_filter :initialize_meta_buttons_and_parts
  before_filter :assets
  before_filter :index_assets,  :only => :index
  before_filter :edit_assets,   :only => :edit
  
  # GET /admin/shop/products
  # GET /admin/shop/products.js
  # GET /admin/shop/products.json                                 AJAX and HTML
  #----------------------------------------------------------------------------
  def index
    @shop_categories = ShopCategory.all
    @shop_products = ShopProduct.search(params[:search])
    
    attr_hash = {
      :include  => { :category => { :only => ShopCategory.params } },
      :only     => ShopProduct.params
    }
    
    respond_to do |format|
      format.html { render :index }
      format.js   { render :partial => '/admin/shop/products/product', :collection => @shop_products }
      format.json { render :json    => @shop_products.to_json(attr_hash) }
    end
  end
  
  # PUT /admin/shop/products/sort
  # PUT /admin/shop/products/sort.js
  # PUT /admin/shop/products/sort.json                            AJAX and HTML
  #----------------------------------------------------------------------------
  def sort
    notice = 'Products successfully sorted.'
    error = 'Could not sort Products.'
    
    begin
      @shop_category = ShopCategory.find(params[:category_id])
      @shop_products = CGI::parse(params[:products])["shop_category_#{params[:category_id]}_products[]"]
      
      @shop_products.each_with_index do |id, index|
        ShopProduct.find(id).update_attributes!({
          :position           => index+1,
          :shop_category_id   => @shop_category.id
        })
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

  # POST /admin/shop/products
  # POST /admin/shop/products.js
  # POST /admin/shop/products.json                                AJAX and HTML
  #----------------------------------------------------------------------------
  def create
    notice = 'Product created successfully.'
    error = 'Could not create Product.'
    
    attr_hash = {
      :include  => { :category => { :only => ShopCategory.params } },
      :only     => ShopProduct.params
    }
    
    begin
      @shop_product = ShopProduct.create!(params[:shop_product])
      
      respond_to do |format|
        format.html { 
          flash[:notice] = notice
          redirect_to edit_admin_shop_product_path(@shop_product) if params[:continue]
          redirect_to admin_shop_products_path unless params[:continue]
        }
        format.js   { render  :partial  => '/admin/shop/products/product', :locals => { :excerpt => @shop_product } }
        format.json { render  :json     => @shop_product.to_json(attr_hash) }
      end
    rescue
      respond_to do |format|
        format.html {
          flash[:error] = error
          render :new
        }
        format.js   { render  :text => error, :status => :unprocessable_entity }
        format.json { render  :json => { :error => error }, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/shop/products/1
  # PUT /admin/shop/products/1.js
  # PUT /admin/shop/products/1.xml
  # PUT /admin/shop/products/1.json                               AJAX and HTML
  #----------------------------------------------------------------------------
  def update
    notice = 'Product updated successfully.'
    error = 'Could not update Product.'
    
    attr_hash = {
      :include  => { :category => { :only => ShopCategory.params } },
      :only     => ShopProduct.params
    }
    
    begin
      @shop_product.update_attributes!(params[:shop_product])

      respond_to do |format|
        format.html { 
          flash[:notice] = notice
          redirect_to edit_admin_shop_product_path(@shop_product) if params[:continue]
          redirect_to admin_shop_products_path unless params[:continue]
        }
        format.js   { render  :partial  => '/admin/shop/products/product', :locals => { :product => @shop_product } }
        format.json { render  :json     => @shop_product.to_json(attr_hash) }
      end
    rescue
      respond_to do |format|
        format.html {
          flash[:error] = error
          render :edit
        }
        format.js   { render  :text => error, :status => :unprocessable_entity }
        format.json { render  :json => { :error => error }, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/shop/products/1
  # DELETE /admin/shop/products/1.js
  # DELETE /admin/shop/products/1.xml
  # DELETE /admin/shop/products/1.json                            AJAX and HTML
  #----------------------------------------------------------------------------
  def destroy
    notice = 'Product deleted successfully.'
    error = 'Could not delete Product.'
    
    begin
      @shop_product.destroy
      
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
          render :remove
        }
        format.js   { render  :text => error, :status => :unprocessable_entity }
        format.json { render  :json => { :error => error }, :status => :unprocessable_entity }
      end
    end
  end
  
private
  
  def initialize_meta_buttons_and_parts
    @meta ||= []
    @meta << 'sku'
    @meta << 'category'
    
    @buttons_partials ||= []
    
    @parts ||= []
    @parts << { :title => 'images' }
    @parts << { :title => 'description' }
  end
  
  def assets
    include_stylesheet 'admin/extensions/shop/products/forms'
  end
  
  def index_assets
    include_javascript 'admin/dragdrop'
    include_javascript 'admin/extensions/shop/products/product_index'
    include_stylesheet 'admin/extensions/shop/products/product_index'
  end
  
  def edit_assets
    include_javascript 'admin/dragdrop'
    include_stylesheet 'admin/extensions/shop/products/product_edit'
    include_javascript 'admin/extensions/shop/products/product_edit'
  end
  
end
