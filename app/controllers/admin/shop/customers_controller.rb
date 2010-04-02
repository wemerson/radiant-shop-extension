class Admin::Shop::CustomersController < Admin::ResourceController
  model_class ShopCustomer
  
  # GET /admin/shop/customers
  # GET /admin/shop/customers.js
  # GET /admin/shop/customers.xml
  # GET /admin/shop/customers.json                                AJAX and HTML
  #----------------------------------------------------------------------------
  def index
    @shop_customers = ShopCustomer.scoped_by_access("front").all
    @shop_customer = ShopCustomer.scoped_by_access("front").new
    attr_hash = {}
    respond_to do |format|
      format.html { render }
      format.js { render :partial => '/admin/shop/customers/excerpt', :collection => @shop_customers }
      format.xml { render :xml => @shop_customers.to_xml(attr_hash) }
      format.json { render :json => @shop_customers.to_json(attr_hash) }
    end
  end
  
  # GET /admin/shop/customers/1
  # GET /admin/shop/customers/1.js
  # GET /admin/shop/customers/1.xml
  # GET /admin/shop/customers/1.json                              AJAX and HTML
  #----------------------------------------------------------------------------
  def show
    @shop_customer = ShopCustomer.scoped_by_access("front").find(params[:id])
    attr_hash = {
      :include => {:orders => {:only => [:id, :balance, :status, :created_at, :updated_at, :payment_id]} },
      :only => [:id, :email, :reference, :created_at, :updated_at, :organization, :notes, :name, :login, :access]
    }
    respond_to do |format|
      format.html { render }
      format.js { render :partial => '/admin/shop/customers/customer', :locals => { :customer => @shop_customer } }
      format.xml { render :xml => @shop_customer.to_xml(attr_hash) }
      format.json { render :json => @shop_customer.to_json(attr_hash) }
    end
  end
  
  # POST /admin/shop/customers
  # POST /admin/shop/customers.js
  # POST /admin/shop/customers.xml
  # POST /admin/shop/customers.json                               AJAX and HTML
  #----------------------------------------------------------------------------
  def create
    @shop_customer = ShopCustomer.new(params[:shop_customer])
    
    if @shop_customer.save!
      respond_to do |format|
        format.html { 
          flash[:notice] = "Customer created successfully."
          redirect_to admin_shop_customers_path 
        }
        format.js { render :partial => '/admin/shop/customers/excerpt', :locals => { :excerpt => @shop_customer } }
        format.xml { redirect_to "/admin/shop/customers/#{@shop_customer.id}.xml" }
        format.json { redirect_to "/admin/shop/customers/#{@shop_customer.id}.json" }
      end
    else
      respond_to do |format|
        format.html { 
          flash[:error] = "Unable to create new customer."
          render
        }
        format.js { render :text => @shop_customer.errors.to_json, :status => :unprocessable_entity }
        format.xml { render :xml => @shop_customer.errors.to_xml, :status => :unprocessable_entity }
        format.json { render :json => @shop_customer.errors.to_json, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /admin/shop/customers/1
  # PUT /admin/shop/customers/1.js
  # PUT /admin/shop/customers/1.xml
  # PUT /admin/shop/customers/1.json                              AJAX and HTML
  #----------------------------------------------------------------------------
  def update
    @shop_customer = ShopCustomer.find(params[:id])
    if @shop_customer.update_attributes!(params[:shop_customer])
      respond_to do |format|
        format.html { 
          flash[:notice] = "Customer updated successfully."
          redirect_to admin_shop_customers_path 
        }
        format.js { render :partial => '/admin/shop/customers/excerpt', :locals => { :excerpt => @shop_customer } }
        format.xml { redirect_to "/admin/shop/customers/#{@shop_customer.id}.xml" }
        format.json { redirect_to "/admin/shop/customers/#{@shop_customer.id}.json" }
      end
    else
      respond_to do |format|
        format.html { 
          flash[:error] = "Unable to update customer."
          render
        }
        format.js { render :text => @shop_customer.errors.to_s, :status => :unprocessable_entity }
        format.xml { render :xml => @shop_customer.errors.to_xml, :status => :unprocessable_entity }
        format.json { render :json => @shop_customer.errors.to_json, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /admin/shop/customers/1
  # DELETE /admin/shop/customers/1.js
  # DELETE /admin/shop/customers/1.xml
  # DELETE /admin/shop/customers/1.json                           AJAX and HTML
  #----------------------------------------------------------------------------
  def destroy
    # Need to rewrite this method to check for errors and return xml or json.
    # For some reason the answer isn't obvious to me.
    @shop_customer = ShopCustomer.find(params[:id])
    
    if (@shop_customer && @shop_customer.orders.empty?)
      @message = "Category deleted successfully."
      @shop_customer.destroy
      
      respond_to do |format|
        format.html {
          flash[:notice] = @message
          redirect_to admin_shop_categories_path
        }
        format.js { render :text => @message, :status => 200 }
        format.xml  { render :xml => {:message => @message}, :status => 200 }
        format.json  { render :json => {:message => @message}, :status => 200 }
      end
    else
      @message = "Unable to delete category."
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
