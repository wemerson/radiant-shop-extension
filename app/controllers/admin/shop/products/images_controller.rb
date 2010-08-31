class Admin::Shop::Products::ImagesController < Admin::ResourceController
  
  model_class ShopProductAttachment
  
  # GET /admin/shop/products/1/images
  # GET /admin/shop/products/1/images.js
  # GET /admin/shop/products/1/images.xml
  # GET /admin/shop/products/1/images.json                        AJAX and HTML
  #----------------------------------------------------------------------------
  def index
    @error    = 'This Product has no Images'
    attr_hash =  ShopProductAttachment.params
    
    @shop_product = ShopProduct.find(params[:shop_product_id])
    @shop_product_images = @shop_product.images
    
    unless @shop_product_images.nil?
      respond_to do |format|
        format.html { render :index }
        format.js   { render :partial => '/admin/shop/products/images/image', :collection => @shop_product_images }
        format.json { render :json    => @shop_product_images.to_json(attr_hash) }
        format.xml  { render :xml     => @shop_product_images.to_xml(attr_hash) }
      end
    else
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
      @shop_product.attachments.find(id).update_attributes({
        :position => index+1
      })
    end

    respond_to do |format|
      format.html { redirect_to edit_admin_shop_product_path(@shop_product) }
      format.js   { render :partial => '/admin/shop/products/images/image', :collection => @shop_product.images }
      format.xml  { render :xml     => @shop_product.to_xml(attr_hash)  }
      format.json { render :json    => @shop_product.to_json(attr_hash) }
    end
  end
  
  # POST /admin/shop/products/images
  # POST /admin/shop/products/images.js
  # POST /admin/shop/products/images.xml
  # POST /admin/shop/products/images.json                         AJAX and HTML
  #----------------------------------------------------------------------------
  def create
    @notice   = 'Successfully created Image.'
    @error    = 'Unable to create Image.'
    attr_hash = ShopProductAttachment.params
    
    @shop_product = ShopProduct.find(params[:product_id])
    
    begin
      if params[:image]
        @image = Image.create!(params[:image])
      elsif params[:attachment]
        @image = Image.find(params[:attachment][:image_id])
      end
      
      @shop_product_attachment = @shop_product.attachments.create!({ :image => @image })
      
      respond_to do |format|
        format.html {
          flash[:notice] = @notice
          redirect_to edit_admin_shop_product_path(@shop_product)
        }
        format.js   { render :partial => '/admin/shop/products/images/image', :locals => { :image => @shop_product_attachment } }
        format.xml  { render :xml     => @shop_product_attachment.to_xml(attr_hash)   }
        format.json { render :json    => @shop_product_attachment.to_json(attr_hash)  }
      end
    rescue Exception => e
      respond_to do |format|
        format.html { 
          flash[:error] = @error
          redirect_to edit_admin_shop_product_path(@shop_product)
        }
        format.js   { render :text  => @shop_product_attachment.errors.to_json, :status => :unprocessable_entity }
        format.json { render :json  => { :message => @error }, :status => :unprocessable_entity }
        format.xml  { render :xml   => { :message => @error }, :status => :unprocessable_entity }
      end
    end
  end
  
  # GET /admin/shop/products/images/1
  # GET /admin/shop/products/images/1.js
  # GET /admin/shop/products/images/1.xml
  # GET /admin/shop/products/images/1.json                        AJAX and HTML
  #----------------------------------------------------------------------------
  def show
    attr_hash = ShopProductAttachment.params
    
    @shop_product_attachment = ShopProductAttachment.find(params[:id])
    
    respond_to do |format|
      format.html { redirect_to edit_admin_shop_product_path(@shop_product_attachment.product) }
      format.js   { render :partial => '/admin/shop/products/images/image', :locals => { :asset => @shop_product_attachment } }
      format.xml  { render :xml     => @shop_product_attachment.to_xml(attr_hash)   }
      format.json { render :json    => @shop_product_attachment.to_json(attr_hash)  }
    end
  end
  
  # DELETE /admin/shop/products/images/1
  # DELETE /admin/shop/products/images/1.js
  # DELETE /admin/shop/products/images/1.xml
  # DELETE /admin/shop/products/images/1.json                     AJAX and HTML
  #----------------------------------------------------------------------------
  def destroy
    @notice = "Image deleted successfully."
    @error  = "Unable to delete Image."
      
    @shop_product_attachment = ShopProductImage.find(params[:id])
    @image = @shop_product_attachment.image
    
    begin
      @shop_product_attachment.destroy      
      
      respond_to do |format|
        format.html {
          flash[:notice] = @notice
          redirect_to admin_shop_products_path
        }
        format.js   { render :partial => '/admin/shop/products/images/image', :locals => { :excerpt => @image } }
        format.xml  { render :xml     => { :message => @notice }, :status => :ok }
        format.json { render :json    => { :message => @notice }, :status => :ok }
      end
    rescue
      respond_to do |format|
        format.html {
          flash[:error] = @error
          render
        }
        format.js   { render :text  => @error, :status => :unprocessable_entity }
        format.xml  { render :xml   => { :message => @error}, :status => :unprocessable_entity }
        format.json { render :xml   => { :message => @error}, :status => :unprocessable_entity }
      end
    end
  end

end