class Admin::Shop::Products::AssetsController < Admin::ResourceController

  # GET /admin/shop/products/assets
  # GET /admin/shop/products/assets.js
  # GET /admin/shop/products/assets.xml
  # GET /admin/shop/products/assets.json                          AJAX and HTML
  # ---------------------------------------------------------------------------
  # GET /admin/shop/products/1/assets
  # GET /admin/shop/products/1/assets.js
  # GET /admin/shop/products/1/assets.xml
  # GET /admin/shop/products/1/assets.json                        AJAX and HTML
  #----------------------------------------------------------------------------
  def index
    @assets = Asset.search(params[:search], params[:filter])
    attr_hash =  {
      :only => [:id, :title, :caption, :asset_file_name, :asset_content_type, :asset_file_size, :original_extension] 
    }
    
    if params[:product_id]
      @shop_product = ShopProduct.find(params[:product_id])
      @assets = @assets - @shop_product.images
    end
    
    unless @assets.nil?
      respond_to do |format|
        format.html { render }
        format.js { render :partial => '/admin/shop/products/assets/excerpt', :collection => @assets }
        format.json { render :json => @assets.to_json(attr_hash) }
        format.xml { render :xml => @assets.to_xml(attr_hash) }
      end
    else
      @message = "No Assets"
      respond_to do |format|
        format.html { 
          flash[:error] = @message
          render 
        }
        format.js { render :partial => '/admin/shop/products/assets/empty' }
        format.json { render :json => {:message => @message} }
        format.xml { render :xml => {:message => @message} }
      end
    end
  end
  
  # GET /admin/shop/products/assets/1
  # GET /admin/shop/products/assets/1.js
  # GET /admin/shop/products/assets/1.xml
  # GET /admin/shop/products/assets/1.json                        AJAX and HTML
  #----------------------------------------------------------------------------
  def show
    @asset = Asset.find(params[:id])
    attr_hash =  {
      :only => [:id, :title, :caption, :asset_file_name, :asset_content_type, :asset_file_size, :original_extension] 
    }
    
    respond_to do |format|
      format.html { render }
      format.js { render :partial => '/admin/shop/assets/category', :locals => { :asset => @asset } }
      format.xml { render :xml => @asset.to_xml(attr_hash) }
      format.json { render :json => @asset.to_json(attr_hash) }
    end
  end
  
  # POST /admin/shop/products/assets
  # POST /admin/shop/products/assets.js
  # POST /admin/shop/products/assets.xml
  # POST /admin/shop/products/assets.json                         AJAX and HTML
  # ---------------------------------------------------------------------------
  def create
    @asset = Asset.new(params[:asset])
    
    if @asset.save
      @asset = Asset.find(@asset.id)
      @asset.update_attributes(params[:asset])
      
      if @asset.asset_content_type.include? "image"
        respond_to do |format|
          format.html { render }
          format.js { 
            responds_to_parent do
              render :update do |page|
                page.insert_html :top, "assets_list", :partial => 'admin/shop/products/assets/excerpt', :locals => { :excerpt => @asset }
                page.call('shop.ProductAssetCreate');
              end
            end
          } 
          format.xml { render :xml => @asset.to_xml(attr_hash) }
          format.json { render :json => @asset.to_json(attr_hash) }
        end
      else
        respond_to do |format|
          @message = "Asset must be an image to be useful to a Product."
          format.html { 
            flash[:error] = @message
            render
          }
          format.js { render :text => @asset.errors.to_json, :status => :unprocessable_entity }
          format.json { render :json => {:message => @message}, :status => 422 }
          format.xml { render :xml => {:message => @message}, :status => 422 }
        end
      end
    else
      respond_to do |format|
        @message = "Unable to create Asset."
        format.html { 
          flash[:error] = @message
          render
        }
        format.js { render :text => @asset.errors.to_json, :status => :unprocessable_entity }
        format.json { render :json => {:message => @message}, :status => 422 }
        format.xml { render :xml => {:message => @message}, :status => 422 }
      end
    end
    
  end
  
end