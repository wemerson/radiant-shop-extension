class Admin::Shop::CategoriesController < Admin::ResourceController
  model_class ShopCategory
  helper :shop

  # GET /admin/shop/products/categories
  # GET /admin/shop/products/categories.js
  # GET /admin/shop/products/categories.xml
  # GET /admin/shop/products/categories.json                      AJAX and HTML
  #----------------------------------------------------------------------------
  def index
    @shop_categories = ShopCategory.search(params[:search])
    attr_hash =  {
      :include => :products,
      :only => [:id, :handle, :created_at, :updated_at, :description, :price, :title, :tags] 
    }
    respond_to do |format|
      format.html { redirect_to admin_shop_products_path }
      format.js { render :partial => '/admin/shop/categories/excerpt', :collection => @shop_categories }
      format.json { render :json => @shop_categories.to_json(attr_hash) }
      format.xml { render :xml => @shop_categories.to_xml(attr_hash) }
    end
  end
  
  # GET /admin/shop/products/categories/1/products
  # GET /admin/shop/products/categories/1/products.js
  # GET /admin/shop/products/categories/1/products.xml
  # GET /admin/shop/products/categories/1/products.json           AJAX and HTML
  #----------------------------------------------------------------------------
  def products
    @shop_category = ShopCategory.find(params[:id])
    attr_hash = {
      :only => [:id, :handle, :created_at, :updated_at, :description, :title]
    }
    respond_to do |format|
      format.html { render }
      format.js { render :partial => '/admin/shop/products/excerpt', :collection => @shop_category.products }
      format.xml { render :xml => @shop_category.products.to_xml(attr_hash) }
      format.json { render :json => @shop_category.products.to_json(attr_hash) }
    end
  end

  # GET /admin/shop/products/categories/1
  # GET /admin/shop/products/categories/1.js
  # GET /admin/shop/products/categories/1.xml
  # GET /admin/shop/products/categories/1.json                    AJAX and HTML
  #----------------------------------------------------------------------------
  def show
    @shop_category = ShopCategory.find(params[:id])
    attr_hash =  { 
      :include => :products,
      :only => [:id, :handle, :created_at, :updated_at, :description, :tags, :title] 
    }
    respond_to do |format|
      format.html { render }
      format.js { render :partial => '/admin/shop/categories/category', :locals => { :category => @shop_category } }
      format.xml { render :xml => @shop_category.to_xml(attr_hash) }
      format.json { render :json => @shop_category.to_json(attr_hash) }
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
      respond_to do |format|
        format.html { 
          flash[:notice] = "Category created successfully."
          redirect_to edit_admin_shop_category_path(@shop_category) if params[:continue]
          redirect_to admin_shop_categories_path unless params[:continue]
        }
        format.js { render :partial => '/admin/shop/categories/excerpt', :locals => { :excerpt => @shop_category } }
        format.xml { redirect_to "/admin/shop/products/categories/#{@shop_category.id}.xml" }
        format.json { redirect_to "/admin/shop/products/categories/#{@shop_category.id}.json" }
      end
    else
      respond_to do |format|
        format.html { 
          flash[:error] = "Unable to create new product."
          render
        }
        format.js { render :text => @shop_category.errors.to_json, :status => :unprocessable_entity }
        format.xml { render :xml => @shop_category.errors.to_xml, :status => :unprocessable_entity }
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
    
    if @shop_category.update_attributes!(params[:shop_category])
      respond_to do |format|
        format.html { 
          flash[:notice] = "Category updated successfully."
          redirect_to edit_admin_shop_category_path(@shop_category) if params[:continue]
          redirect_to admin_shop_categories_path unless params[:continue]
        }
        format.js { render :partial => '/admin/shop/categories/excerpt', :locals => { :excerpt => @shop_category } }
        format.xml { redirect_to "/admin/shop/products/categories/#{@shop_category.id}.xml" }
        format.json { redirect_to "/admin/shop/products/categories/#{@shop_category.id}.json" }
      end
    else
      respond_to do |format|
        format.html { 
          flash[:error] = "Unable to update new category."
          render
        }
        format.js { render :text => @shop_category.errors.to_s, :status => :unprocessable_entity }
        format.xml { render :xml => @shop_category.errors.to_xml, :status => :unprocessable_entity }
        format.json { render :json => @shop_category.errors.to_json, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/shop/products/categories/1
  # DELETE /admin/shop/products/categories/1.js
  # DELETE /admin/shop/products/categories/1.xml
  # DELETE /admin/shop/products/categories/1.json                 AJAX and HTML
  #----------------------------------------------------------------------------
  def destroy
    # Need to rewrite this method to check for errors and return xml or json.
    # For some reason the answer isn't obvious to me.
    # DK - The conditional doesn't actually work...
    @shop_category = ShopCategory.find(params[:id])

    if @shop_category and @shop_category.destroy
      @message = "Category deleted successfully."
      
      respond_to do |format|
        format.html {
          flash[:notice] = @message
          redirect_to admin_shop_products_path
        }
        format.js { render :text => @message, :status => 200 }
        format.xml { render :xml => {:message => @message}, :status => 200 }
        format.json { render :json => {:message => @message}, :status => 200 }
      end
    else
      @message = "Unable to delete category."
      
      respond_to do |format|
        format.html {
          flash[:error] = @message
        }
        format.js { render :text => @message, :status => 422 }
        format.xml { render :xml => {:message => @message}, :status => 422 }
        format.json { render :json => {:message => @message}, :status => 422 }
      end
    end
  end 
  
end
