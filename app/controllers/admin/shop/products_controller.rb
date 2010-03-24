class Admin::Shop::ProductsController < Admin::ResourceController
  model_class ShopProduct
  helper :shop

  # GET /shop/products
  # GET /shop/products.xml
  # GET /shop/products.json                                       AJAX and HTML
  #----------------------------------------------------------------------------
  def index
    @shop_categories = ShopCategory.search(params[:psearch], params[:pfilter], params[:ppage])
    @shop_products = ShopProduct.search(params[:psearch], params[:pfilter], params[:ppage])
    attr_hash = {
      :include => {:category => {:only => [:id, :title]} },
      :only => [:id, :sku, :handle, :created_at, :updated_at, :price, :title]
    }
    respond_to do |format|
      format.html { render }
      format.js { render :partial => '/admin/shop/products/product', :collection => @shop_products }
      format.xml { render :xml => @shop_products.to_xml(attr_hash) }
      format.json { render :json => @shop_products.to_json(attr_hash) }
    end
  end


  # GET /shop/products/1
  # GET /shop/products/1.xml
  # GET /shop/products/1.json                                     AJAX and HTML
  #----------------------------------------------------------------------------
  def show
    @shop_product = ShopProduct.find(params[:id])
    attr_hash =  {  :include => {:category => {:only => [:id, :title]}},
                    :only => [:id, :sku, :handle, :created_at, :updated_at, :description, :price, :title] 
    }
    respond_to do |format|
      format.html { render }
      format.js { render :partial => '/admin/shop/products/product', :locals => { :product => @shop_product } }
      format.xml { render :xml => @shop_product.to_xml(attr_hash) }
      format.json { render :json => @shop_product.to_json(attr_hash) }
    end
  end

  # POST /shop/products
  # POST /shop/products.xml
  # POST /shop/products.json                                      AJAX and HTML
  #----------------------------------------------------------------------------
  def create
    @shop_product = ShopProduct.new(params[:shop_product])
    
    if @shop_product.save!
      respond_to do |format|
        flash[:notice] = "Product created successfully."
        format.html { redirect_to admin_shop_products_path }
        format.js { redirect_to "/admin/shop/products/#{@shop_product.id}.js" }
        format.xml { redirect_to "/admin/shop/products/#{@shop_product.id}.xml" }
        format.json { redirect_to "/admin/shop/products/#{@shop_product.id}.json" }
      end
    else
      respond_to do |format|
        flash[:error] = "Unable to create new product."
        format.html { }
        format.js { render :text => @shop_product.errors.to_s, :status => 422 }
        format.xml { render :xml => @shop_product.errors.to_xml, :status => 422 }
        format.json { render :json => @shop_product.errors.to_json, :status => 422 }
      end
    end
  end

  # PUT /shop/products/1
  # PUT /shop/products/1.xml
  # PUT /shop/products/1.json                                     AJAX and HTML
  #----------------------------------------------------------------------------
  def update
    @shop_product = ShopProduct.find(params[:id])
    if @shop_product.update_attributes!(params[:shop_product])
      respond_to do |format|
        flash[:notice] = "Product updated successfully."
        format.html { redirect_to admin_shop_products_path }
        format.js { redirect_to "/admin/shop/products/#{@shop_product.id}.js" }
        format.xml { redirect_to "/admin/shop/products/#{@shop_product.id}.xml" }
        format.json { redirect_to "/admin/shop/products/#{@shop_product.id}.json" }
      end
    else
      respond_to do |format|
        flash[:error] = "Unable to update new product."
        format.html { }
        format.js { render :text => @shop_product.errors.to_s, :status => 422 }
        format.xml { render :xml => @shop_product.errors.to_xml, :status => 422 }
        format.json { render :json => @shop_product.errors.to_json, :status => 422 }
      end
    end
  end   

  # DELETE /shop/products/1
  # DELETE /shop/products/1.xml
  # DELETE /shop/products/1.json                                  AJAX and HTML
  #----------------------------------------------------------------------------
  def destroy
    # Need to rewrite this method to check for errors and return xml or json.
    # For some reason the answer isn't obvious to me.
    @shop_product = ShopProduct.find(params[:id])
    @shop_product.destroy if @shop_product
    respond_to do |format|
      flash[:notice] = "Product deleted successfully."
      format.html { redirect_to admin_shop_products_path }
      format.js  { render :text => {:message => "Product deleted successfully."}, :status => 200 }
      format.xml  { render :xml => {:message => "Product deleted successfully."}, :status => 200 }
      format.json  { render :json => {:message => "Product deleted successfully."}, :status => 200 }
    end
  end   
  
end
