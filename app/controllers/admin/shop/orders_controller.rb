class Admin::Shop::OrdersController < Admin::ResourceController
  model_class ShopOrder
  
  # GET /admin/shop/orders
  # GET /admin/shop/orders.js
  # GET /admin/shop/orders.xml
  # GET /admin/shop/orders.json                                   AJAX and HTML
  #----------------------------------------------------------------------------
  def index
    @shop_orders = ShopOrder.search(params[:search], params[:filter], params[:page])
    @shop_order = ShopOrder.new
    @shop_order.line_items.build
    attr_hash = {
      :methods => [:sub_total, :balance],
      :include => {
        :customer => {
          :include => {
            :addresses => {:only => [ :street, :city, :state, :zip, :country, :unit, :atype ]}
          },
          :only => [:id, :name, :email, :organization]
        },
        :line_items => {
          :methods => [:total],
          :include => {
            :product => {:only => [:id, :sku, :description, :handle, :price, :title]},
          },
          :only => [:id, :quantity]
        }
      },
      :only => [:id, :status, :created_at, :updated_at]
    }
    
    respond_to do |format|
      format.html { render }
      format.js { render :partial => '/admin/shop/orders/excerpt', :collection => @shop_orders }
      format.xml { render :xml => @shop_orders.to_xml(attr_hash) }
      format.json { render :json => @shop_orders.to_json(attr_hash) }
    end
  end
  
  # GET /admin/shop/orders/1
  # GET /admin/shop/orders/1.js
  # GET /admin/shop/orders/1.xml
  # GET /admin/shop/orders/1.json                                 AJAX and HTML
  #----------------------------------------------------------------------------
  def show
    @shop_order = ShopOrder.find(params[:id])
    attr_hash = {
      :methods => [:sub_total, :balance],
      :include => {
        :customer => {
          :include => {
            :addresses => {:only => [ :street, :city, :state, :zip, :country, :unit, :atype ]}
          },
          :only => [:id, :name, :email, :organization]
        },
        :line_items => {
          :methods => [:total],
          :include => {
            :product => {:only => [:id, :sku, :description, :handle, :price, :title]},
          },
          :only => [:id, :quantity]
        }
      },
      :only => [:id, :status, :created_at, :updated_at]
    }
    respond_to do |format|
      format.html { render }
      format.js { render :partial => '/admin/shop/orders/order', :locals => { :order => @shop_order } }
      format.xml { render :xml => @shop_order.to_xml(attr_hash) }
      format.json { render :json => @shop_order.to_json(attr_hash) }
    end
  end
  
  # POST /admin/shop/orders
  # POST /admin/shop/orders.js
  # POST /admin/shop/orders.xml
  # POST /admin/shop/orders.json                                  AJAX and HTML
  #----------------------------------------------------------------------------
  def create                                     
    @shop_order = ShopOrder.new(params[:shop_order])
    
    if @shop_order.save!
      respond_to do |format|
        format.html { 
          flash[:notice] = "Order created successfully."
          redirect_to admin_shop_orders_path 
        }
        format.js { render :partial => '/admin/shop/orders/excerpt', :locals => { :excerpt => @shop_order } }
        format.xml { redirect_to "/admin/shop/orders/#{@shop_order.id}.xml" }
        format.json { redirect_to "/admin/shop/orders/#{@shop_order.id}.json" }
      end
    else
      respond_to do |format|
        format.html { 
          flash[:error] = "Unable to create new customer."
          render
        }
        format.js { render :text => @shop_order.errors.to_json, :status => :unprocessable_entity }
        format.xml { render :xml => @shop_order.errors.to_xml, :status => :unprocessable_entity }
        format.json { render :json => @shop_order.errors.to_json, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /shop/orders/1
  # PUT /shop/orders/1.xml
  # PUT /shop/orders/1.json                                        AJAX and HTML
  #-----------------------------------------------------------------------------
  def update
    @shop_order = ShopOrder.find(params[:id])
    if @shop_order.update_attributes!(params[:shop_order])
      respond_to do |format|
        format.html { 
          flash[:notice] = "Order updated successfully."
          redirect_to admin_shop_customers_path 
        }
        format.js { render :partial => '/admin/shop/orders/excerpt', :locals => { :excerpt => @shop_order } }
        format.xml { redirect_to "/admin/shop/orders/#{@shop_order.id}.xml" }
        format.json { redirect_to "/admin/shop/orders/#{@shop_order.id}.json" }
      end
    else
      respond_to do |format|
        format.html { 
          flash[:error] = "Unable to update order."
          render
        }
        format.js { render :text => @shop_order.errors.to_s, :status => :unprocessable_entity }
        format.xml { render :xml => @shop_order.errors.to_xml, :status => :unprocessable_entity }
        format.json { render :json => @shop_order.errors.to_json, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /admin/shop/orders/1
  # DELETE /admin/shop/orders/1.js
  # DELETE /admin/shop/orders/1.xml
  # DELETE /admin/shop/orders/1.json                              AJAX and HTML
  #----------------------------------------------------------------------------
  def destroy
    # Need to rewrite this method to check for errors and return xml or json.
    # For some reason the answer isn't obvious to me.
    @shop_order = ShopOrder.find(params[:id])
    
    if @shop_order
      @message = "Order deleted successfully."
      @shop_order.destroy
      
      respond_to do |format|
        format.html {
          flash[:notice] = @message
          redirect_to admin_shop_orders_path
        }
        format.js { render :text => @message, :status => 200 }
        format.xml  { render :xml => {:message => @message}, :status => 200 }
        format.json  { render :json => {:message => @message}, :status => 200 }
      end
    else
      @message = "Unable to delete order."
      respond_to do |format|
        format.html {
          flash[:error] = @message
        }
        format.js { render :text => @message, :status => :unprocessable_entity }
        format.xml  { render :xml => {:message => @message}, :status => :unprocessable_entity }
        format.json  { render :json => {:message => @message}, :status => :unprocessable_entity }
      end
    end
  end
  
end
