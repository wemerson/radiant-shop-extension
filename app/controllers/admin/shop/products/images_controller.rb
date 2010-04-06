class Admin::Shop::Products::ImagesController < Admin::ResourceController
  model_class ShopProductImage
  
  # GET /admin/shop/products/images
  # GET /admin/shop/products/images.js
  # GET /admin/shop/products/images.xml
  # GET /admin/shop/products/images.json                          AJAX and HTML
  # ---------------------------------------------------------------------------
  # GET /admin/shop/products/1/images
  # GET /admin/shop/products/1/images.js
  # GET /admin/shop/products/1/images.xml
  # GET /admin/shop/products/1/images.json                        AJAX and HTML
  #----------------------------------------------------------------------------
  def index
    
    if params[:product_id]
      @shop_product = ShopProduct.find(params[:product_id])
      @shop_product_images = @shop_product.assets
    else
      @shop_product_images = ShopProductImage.all
    end
    
    attr_hash =  {
      :only => [:id, :title, :caption, :asset_file_name, :asset_content_type, :asset_file_size, :original_extension] 
    }
    
    unless @shop_product_images.nil?
      respond_to do |format|
        format.html { render }
        format.js { render :partial => '/admin/shop/products/images/excerpt', :collection => @shop_product_images }
        format.json { render :json => @shop_product_images.to_json(attr_hash) }
        format.xml { render :xml => @shop_product_images.to_xml(attr_hash) }
      end
    else
      @message = "No Images"
      respond_to do |format|
        format.html { 
          flash[:error] = @message
          render 
        }
        format.js { render :partial => '/admin/shop/products/images/empty' }
        format.json { render :json => {:message => @message} }
        format.xml { render :xml => {:message => @message} }
      end
    end
  end
  
  # POST /admin/shop/products/images
  # POST /admin/shop/products/images.js
  # POST /admin/shop/products/images.xml
  # POST /admin/shop/products/images.json                         AJAX and HTML
  #----------------------------------------------------------------------------
  def create 
    @shop_product = ShopProduct.find(params[:product_id])
    @shop_product_image = @shop_product.assets.new(params[:shop_product_image])
    
    attr_hash =  {
      :include => :gallery,
      :only => [:id, :handle, :title, :caption] 
    }
    
    if @shop_product_image.save
      respond_to do |format|
        format.html { render }
        format.js { render :partial => '/admin/shop/products/images/excerpt', :locals => { :excerpt => @shop_product_image } }
        format.xml { render :xml => @shop_product_image.to_xml(attr_hash) }
        format.json { render :json => @shop_product_image.to_json(attr_hash) }
      end
    else
      respond_to do |format|
        format.html { 
          flash[:error] = "Unable to create new item."
          render
        }
        format.js { render :text => @shop_product_image.errors.to_json, :status => :unprocessable_entity }
        format.json { render :json => {:message => @message}, :status => 422 }
        format.xml { render :xml => {:message => @message}, :status => 422 }
      end
    end
  end
  
  # GET /admin/shop/products/images/1
  # GET /admin/shop/products/images/1.js
  # GET /admin/shop/products/images/1.xml
  # GET /admin/shop/products/images/1.json                        AJAX and HTML
  #----------------------------------------------------------------------------
  def show
    @shop_product_image = ShopProductImage.find(params[:id])
    attr_hash =  {
      :only => [:id, :title, :caption, :asset_file_name, :asset_content_type, :asset_file_size, :original_extension] 
    }
    
    respond_to do |format|
      format.html { render }
      format.js { render :partial => '/admin/shop/assets/category', :locals => { :asset => @shop_product_image } }
      format.xml { render :xml => @shop_product_image.to_xml(attr_hash) }
      format.json { render :json => @shop_product_image.to_json(attr_hash) }
    end
  end
  
  # DELETE /admin/shop/products/images/1
  # DELETE /admin/shop/products/images/1.js
  # DELETE /admin/shop/products/images/1.xml
  # DELETE /admin/shop/products/images/1.json                     AJAX and HTML
  #----------------------------------------------------------------------------
  def destroy
    @shop_product_image = ShopProductImage.find(params[:id])
    @asset = @shop_product_image.image
    
    if @shop_product_image.destroy
      @message = "Image deleted successfully."
      
      respond_to do |format|
        format.html {
          flash[:notice] = @message
          redirect_to admin_shop_products_images_path
        }
        format.js { render :partial => '/admin/shop/products/assets/excerpt', :locals => { :excerpt => @asset } }
        format.xml { render :xml => { :message => @message}, :status => 200 }
        format.json { render :json => { :message => @message}, :status => 200}
      end
    else
      @message = "Unable to delete image"
      
      respond_to do |format|
        format.html {
          flash[:error] = @message
          render
        }
        format.js { render :text => @message, :status => :unprocessable_entity }
        format.xml { render :xml => { :message => @message}, :status => :unprocessable_entity }
        format.json { render :xml => { :message => @message}, :status => :unprocessable_entity }
      end
    end
  end

end