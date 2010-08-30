class Admin::Shop::CategoriesController < Admin::ResourceController
  
  model_class ShopCategory
  
  before_filter :initialize_meta_buttons_and_parts
    
  # GET /admin/shop/products/categories
  # GET /admin/shop/products/categories.js
  # GET /admin/shop/products/categories.xml
  # GET /admin/shop/products/categories.json                      AJAX and HTML
  #----------------------------------------------------------------------------
  def index
    @shop_categories = ShopCategory.search(params[:search])
    
    attr_hash = {
      :include  => { :products => { :only => ShopProduct.params } },
      :only     => ShopCategory.params
    }
    
    respond_to do |format|
      format.html { redirect_to admin_shop_products_url }
      format.js   { render :partial => '/admin/shop/categories/category', :collection => @shop_categories }
      format.json { render :json => @shop_categories.to_json(attr_hash) }
      format.xml  { render :xml => @shop_categories.to_xml(attr_hash) }
    end
  end
  
  # GET /admin/shop/products/categories/1/products
  # GET /admin/shop/products/categories/1/products.js
  # GET /admin/shop/products/categories/1/products.xml
  # GET /admin/shop/products/categories/1/products.json           AJAX and HTML
  #----------------------------------------------------------------------------
  def products
    @shop_category = ShopCategory.find(params[:id])
    @shop_categories = [ @shop_category ]
    @shop_products = @shop_category.products
    
    attr_hash = {
      :only     => ShopCategory.params
    }
    
    respond_to do |format|
      format.html { render :template => '/admin/shop/products/index' }
      format.js   { render :partial => '/admin/shop/products/product', :collection => @shop_products }
      format.xml  { render :xml => @shop_products.to_xml(attr_hash) }
      format.json { render :json => @shop_products.to_json(attr_hash) }
    end
  end
  
  # PUT /admin/shop/categories/sort
  # PUT /admin/shop/categories/sort.js
  # PUT /admin/shop/categories/sort.xml
  # PUT /admin/shop/categories/sort.json                          AJAX and HTML
  #----------------------------------------------------------------------------
  def sort    
    begin  
      @shop_categories = CGI::parse(params[:categories])["shop_categories[]"]
      
      @shop_categories.each_with_index do |id, index|
        ShopCategory.find(id).update_attribute('position', index+1)
      end
      
      respond_to do |format|
        notice = t('shop_categories') + ' ' + t('flash.successfully_sorted')
        
        format.html {
          flash[:notice] = notice
          redirect_to admin_shop_products_url
        }
        format.js   { render  :text => notice, :status => 200 }
        format.xml  { render  :xml  => { :message => notice }, :status => 200 }
        format.json { render  :json => { :message => notice }, :status => 200 }
      end
    rescue Exception => e
      respond_to do |format|
        error = t('flash.could_not_sort') + ' ' + t('shop_categories')
        
        format.html {
          flash[:error] = error
          redirect_to admin_shop_products_url
        }
        format.js   { render  :text => error, :status => :unprocessable_entity }
        format.xml  { render  :xml  => error, :status => :unprocessable_entity }
        format.json { render  :json => error, :status => :unprocessable_entity }
      end
    end
  end
  
  # GET /admin/shop/products/categories/1
  # GET /admin/shop/products/categories/1.js
  # GET /admin/shop/products/categories/1.xml
  # GET /admin/shop/products/categories/1.json                    AJAX and HTML
  #----------------------------------------------------------------------------
  def show
    @shop_category = ShopCategory.find(params[:id])
    
    attr_hash = {
      :include  => { :products => { :only => ShopProduct.params } },
      :only     => ShopCategory.params
    }
    
    respond_to do |format|
      format.html { render :show }
      format.js   { render :partial => '/admin/shop/categories/category', :locals => { :category => @shop_category } }
      format.xml  { render :xml     => @shop_category.to_xml(attr_hash) }
      format.json { render :json    => @shop_category.to_json(attr_hash) }
    end
  end
  
  # POST /admin/shop/products/categories
  # POST /admin/shop/products/categories.js
  # POST /admin/shop/products/categories.xml
  # POST /admin/shop/products/categories.json                     AJAX and HTML
  #----------------------------------------------------------------------------
  def create
    @shop_category = ShopCategory.new(params[:shop_category])
    
    if @shop_category.save
      notice = t('shop_category') + ' ' + t('flash.successfully_created')
      
      respond_to do |format|
        format.html { 
          flash[:notice] = notice
          
          redirect_to edit_admin_shop_category_path(@shop_category) if params[:continue]
          redirect_to admin_shop_categories_path unless params[:continue]
        }
        format.js   { render :partial => '/admin/shop/categories/category', :locals => { :product => @shop_category } }
        format.xml  { redirect_to "/admin/shop/products/categories/#{@shop_category.id}.xml" }
        format.json { redirect_to "/admin/shop/products/categories/#{@shop_category.id}.json" }
      end
    else
      error = t('flash.could_not_create') + ' ' + t('shop_category')
      
      respond_to do |format|
        format.html { 
          flash[:error] = error
          render :new
        }
        format.js   { render :text => @shop_category.errors.to_json, :status => :unprocessable_entity }
        format.xml  { render :xml => @shop_category.errors.to_xml, :status => :unprocessable_entity }
        format.json { render :json => @shop_category.errors.to_json, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/shop/products/categories/1
  # PUT /admin/shop/products/categories/1.js
  # PUT /admin/shop/products/categories/1.xml
  # PUT /admin/shop/products/categories/1.json                    AJAX and HTML
  #----------------------------------------------------------------------------
  def update
    @shop_category = ShopCategory.find(params[:id])
    
    if @shop_category.update_attributes(params[:shop_category])
      notice = t('shop_category') + ' ' + t('flash.successfully_updated')
      
      respond_to do |format|
        format.html { 
          flash[:notice] = notice
          redirect_to edit_admin_shop_category_path(@shop_category) if params[:continue]
          redirect_to admin_shop_categories_path unless params[:continue]
        }
        format.js   { render :partial => '/admin/shop/categories/category', :locals => { :product => @shop_category } }
        format.xml  { redirect_to "/admin/shop/products/categories/#{@shop_category.id}.xml" }
        format.json { redirect_to "/admin/shop/products/categories/#{@shop_category.id}.json" }
      end
    else
      error = t('flash.could_not_update') + ' ' + t('shop_category')
      
      respond_to do |format|
        format.html { 
          flash[:error] = error
          render :edit
        }
        format.js   { render :text  => @shop_category.errors.to_s,    :status => :unprocessable_entity }
        format.xml  { render :xml   => @shop_category.errors.to_xml,  :status => :unprocessable_entity }
        format.json { render :json  => @shop_category.errors.to_json, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/shop/products/categories/1
  # DELETE /admin/shop/products/categories/1.js
  # DELETE /admin/shop/products/categories/1.xml
  # DELETE /admin/shop/products/categories/1.json                 AJAX and HTML
  #----------------------------------------------------------------------------
  def destroy
    @shop_category = ShopCategory.find(params[:id])

    if @shop_category.destroy
      notice = t('shop_category') + ' ' + t('flash.successfully_destroyed')
      
      respond_to do |format|
        format.html {
          flash[:notice] = notice
          redirect_to admin_shop_categories_path
        }
        format.js   { render :text  => notice, :status => 200 }
        format.xml  { render :xml   => { :message => notice }, :status => 200 }
        format.json { render :json  => { :message => notice }, :status => 200 }
      end
    else
      error = t('flash.couldnt_destroy') + ' ' + t('shop_category')
      
      respond_to do |format|
        format.html {
          flash[:error] = error
          render
        }
        format.js   { render :text  => error, :status => :unprocessable_entity }
        format.xml  { render :xml   => { :message => error }, :status => :unprocessable_entity }
        format.json { render :json  => { :message => error }, :status => :unprocessable_entity }
      end
    end
  end
  
private

  def initialize_meta_buttons_and_parts
    @meta ||= []
    @meta << {:field => "handle", :type => "text_field", :args => [{:class => 'textbox', :maxlength => 160}]}
    
    @buttons_partials ||= []
    
    @parts ||= []
    @parts << {:title => 'description'}
  end
  
end