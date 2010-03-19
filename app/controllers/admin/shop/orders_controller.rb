class Admin::Shop::OrdersController < Admin::ResourceController
  model_class ShopOrder

  # GET /shop/orders
  # GET /shop/orders.xml                                               
  # GET /shop/orders.json                                         AJAX and HTML
  #----------------------------------------------------------------------------  
  def index
	  @shop_orders = ShopOrder.search(params[:search], params[:filter], params[:page])
    @shop_order = ShopOrder.new
    attr_hash = {
      :include => {
        :customer => {:only => [:id, :name, :email, :organization]},
        :products => {:only => [:id, :sku, :description, :handle, :created_at, :updated_at, :price, :title]}
      },
      :only => [:id, :balance, :status, :created_at, :updated_at]
    }
	  respond_to do |format|
      format.html { }
      format.xml { render :xml => @shop_orders.to_xml(attr_hash) }
      format.json { render :json => @shop_orders.to_json(attr_hash) }
    end
  end


  # GET /shop/orders/1
  # GET /shop/orders/1.xml                                               
  # GET /shop/orders/1.json                                       AJAX and HTML
  #----------------------------------------------------------------------------  
  def show
    @shop_order = ShopOrder.find(params[:id])
    attr_hash = {
      :include => {
        :customer => {:only => [:id, :name, :email, :organization]}, 
        :products => {:only => [:id, :sku, :description, :handle, :created_at, :updated_at, :price, :title]}
      },
      :only => [:id, :balance, :status, :created_at, :updated_at]
    }
    respond_to do |format|
      format.html {}
      format.xml { render :xml => @shop_order.to_xml(attr_hash) }
      format.json { render :json => @shop_order.to_json(attr_hash) }
    end
  end

  # POST /shop/orders
  # POST /shop/orders.xml                                               
  # POST /shop/orders.json                                      AJAX and HTML
  #----------------------------------------------------------------------------  
  def create                                     
    @shop_order = ShopOrder.new(params[:shop_order])
    
    if @shop_order.save!
      respond_to do |format|
        flash[:notice] = "Order created successfully."
        format.html { redirect_to admin_shop_orders_path }
        format.xml { redirect_to "/admin/shop/orders/#{@shop_order.id}.xml" }
        format.json { redirect_to "/admin/shop/orders/#{@shop_order.id}.json" }
      end
    else
      respond_to do |format|
        flash[:error] = "Unable to create new order."
        format.html { }
        format.xml { render :xml => @shop_order.errors.to_xml, :status => 422 }
        format.json { render :json => @shop_order.errors.to_json, :status => 422 }
      end
    end
  end

  # PUT /shop/orders/1
  # PUT /shop/orders/1.xml                                               
  # PUT /shop/orders/1.json                                    AJAX and HTML
  #---------------------------------------------------------------------------- 
  def update                                     
    @shop_order = ShopOrder.find(params[:id])
    if @shop_order.update_attributes!(params[:shop_order])
      respond_to do |format|
        flash[:notice] = "Order updated successfully."
        format.html { redirect_to admin_shop_orders_path }
        format.xml { redirect_to "/admin/shop/orders/#{@shop_order.id}.xml" }
        format.json { redirect_to "/admin/shop/orders/#{@shop_order.id}.json" }
      end
    else
      respond_to do |format|
        flash[:error] = "Unable to update new order."
        format.html { }
        format.xml { render :xml => @shop_order.errors.to_xml, :status => 422 }
        format.json { render :json => @shop_order.errors.to_json, :status => 422 }
      end
    end
  end   

  # DELETE /shop/orders/1
  # DELETE /shop/orders/1.xml                                               
  # DELETE /shop/orders/1.json                                    AJAX and HTML
  #---------------------------------------------------------------------------- 
  def destroy
    # Need to rewrite this method to check for errors and return xml or json.
    # For some reason the answer isn't obvious to me.
    @shop_order = ShopOrder.find(params[:id])
    @shop_order.destroy if @shop_order
    respond_to do |format|
      flash[:notice] = "Order deleted successfully."
      format.html { redirect_to admin_shop_orders_path }
      format.xml  { render :xml => {:message => "Order deleted successfully."}, :status => 200 }
      format.json  { render :json => {:message => "Order deleted successfully."}, :status => 200 }
    end
  end   

end
