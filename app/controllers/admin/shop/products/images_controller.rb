class Admin::Shop::Products::ImagesController < Admin::ResourceController
  model_class ShopProductImage
  
  # GET /admin/shop/products/1/images
  # GET /admin/shop/products/1/images.js
  # GET /admin/shop/products/1/images.xml
  # GET /admin/shop/products/1/images.json                        AJAX and HTML
  #----------------------------------------------------------------------------
  def index
    @shop_product = ShopProduct.find(params[:shop_product_id])
    @shop_product_images = @shop_product.images
    
    @error = 'This product has no images'
    
    attr_hash =  {
      :only => [:id, :title, :caption, :asset_file_name, :asset_content_type, :asset_file_size, :original_extension] 
    }
    
    unless @shop_product_images.nil?
      respond_to do |format|
        format.html { render :index }
        format.js   { render :partial => '/admin/shop/products/images/image', :collection => @shop_product_images }
        format.json { render :json    => @shop_product_images.to_json(attr_hash) }
        format.xml  { render :xml     => @shop_product_images.to_xml(attr_hash) }
      end
    else
      @message = "This Product has no Images."
      respond_to do |format|
        format.html { 
          flash[:error] = @error
          render :index
        }
        format.js   { render :partial => '/admin/shop/products/images/empty' }
        format.json { render :json    => { :message => @error } }
        format.xml  { render :xml     => { :message => @error } }
      end
    end
  end

  # PUT /admin/shop/products/1/images/sort
  # PUT /admin/shop/products/1/images/sort.js
  # PUT /admin/shop/products/1/images/sort.xml
  # PUT /admin/shop/products/1/images/sort.json                   AJAX and HTML
  #----------------------------------------------------------------------------
  def sort
    @shop_product = ShopProduct.find(params[:product_id])

    @images = CGI::parse(params[:attachments])['product_attachments[]']
    @images.each_with_index do |id, index|
      @shop_product.attachments.update_all(['position=?', index+1], ['id=?', id])
    end

    respond_to do |format|
      format.html { render }
      format.js   { render :partial => '/admin/shop/products/images/image', :collection => @shop_product.images }
      format.xml  { render :xml => @shop_product.to_xml(attr_hash) }
      format.json { render :json => @shop_product.to_json(attr_hash) }
    end
  end
  
  # POST /admin/shop/products/images
  # POST /admin/shop/products/images.js
  # POST /admin/shop/products/images.xml
  # POST /admin/shop/products/images.json                         AJAX and HTML
  #----------------------------------------------------------------------------
  def create
    @shop_product = ShopProduct.find(params[:product_id])
    
    @error = 'Unable to create image.'
    
    if params[:image]
      @image = Image.create!(params[:image])
    elsif params[:attachment]
      @image = Image.find(params[:attachment][:image_id])
    end
    
    @shop_product_attachment = @shop_product.attachments.new({
      :product  => @shop_product,
      :image    => @image
    })
    
    if @shop_product_attachment.save
      respond_to do |format|
        format.html { redirect_to edit_admin_shop_product_path(@shop_product) }
        format.js   { render :partial => '/admin/shop/products/images/image', :locals => { :image => @shop_product_attachment } }
        format.xml  { render :xml => @shop_product_attachment.to_xml(attr_hash) }
        format.json { render :json => @shop_product_attachment.to_json(attr_hash) }
      end
    else
      respond_to do |format|
        format.html { 
          flash[:error] = @error
          render :new
        }
        format.js   { render :text => @shop_product_attachment.errors.to_json, :status => :unprocessable_entity }
        format.json { render :json => { :message => @error }, :status => :unprocessable_entity }
        format.xml  { render :xml =>  { :message => @error }, :status => :unprocessable_entity }
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
      format.js { render :partial => '/admin/shop/products/images/image', :locals => { :asset => @shop_product_image } }
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
    @image = @shop_product_image.image
    
    if @shop_product_image.destroy
      @message = "Image deleted successfully."
      
      respond_to do |format|
        format.html {
          flash[:notice] = @message
          redirect_to admin_shop_products_images_path
        }
        format.js { render :partial => '/admin/shop/products/images/image', :locals => { :excerpt => @image } }
        format.xml { render :xml => { :message => @message}, :status => 200 }
        format.json { render :json => { :message => @message}, :status => 200}
      end
    else
      @message = "Unable to delete image."
      
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