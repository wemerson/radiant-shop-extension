class Admin::Shop::CustomersController < Admin::ResourceController
  model_class ShopCustomer
  only_allow_access_to :index, :show, :new, :create, :edit, :update, :remove, :destroy,
      :when => [:admin, :designer],
      :denied_url => :back,
      :denied_message => "You don't have permission to access this page."
  
  # GET /shop/customers
  # GET /shop/customers.xml                                               
  # GET /shop/customers.json                                         AJAX and HTML
  #----------------------------------------------------------------------------  
  def index
	  @shop_customers = ShopCustomer.scoped_by_access("front").all
    @shop_customer = ShopCustomer.scoped_by_access("front").new
    attr_hash = {}
	  respond_to do |format|
      format.html { }
      format.xml { render :xml => @shop_customers.to_xml(attr_hash) }
      format.json { render :json => @shop_customers.to_json(attr_hash) }
    end
  end

  # GET /shop/customers/1
  # GET /shop/customers/1.xml                                               
  # GET /shop/customers/1.json                                       AJAX and HTML
  #----------------------------------------------------------------------------  
  def show
    @shop_customer = ShopCustomer.scoped_by_access("front").find(params[:id])
    attr_hash = {
      :include => {:orders => {:only => [:id, :balance, :status, :created_at, :updated_at, :payment_id]} },
      :only => [:id, :email, :reference, :created_at, :updated_at, :organization, :notes, :name, :login, :access]
    }
    respond_to do |format|
      format.html {}
      format.xml { render :xml => @shop_customer.to_xml(attr_hash) }
      format.json { render :json => @shop_customer.to_json(attr_hash) }
    end
  end

  # POST /shop/customers
  # POST /shop/customers.xml                                               
  # POST /shop/customers.json                                      AJAX and HTML
  #----------------------------------------------------------------------------  
  def create                                     
    @shop_customer = ShopCustomer.new(params[:shop_customer])
    
    if @shop_customer.save!
      respond_to do |format|
        flash[:notice] = "Customer created successfully."
        format.html { redirect_to admin_shop_customers_path }
        format.xml { redirect_to "/admin/shop/customers/#{@shop_customer.id}.xml" }
        format.json { redirect_to "/admin/shop/customers/#{@shop_customer.id}.json" }
      end
    else
      respond_to do |format|
        flash[:error] = "Unable to create new customer."
        format.html { }
        format.xml { render :xml => @shop_customer.errors.to_xml, :status => 422 }
        format.json { render :json => @shop_customer.errors.to_json, :status => 422 }
      end
    end
  end

  # PUT /shop/customers/1
  # PUT /shop/customers/1.xml
  # PUT /shop/customers/1.json                                     AJAX and HTML
  #----------------------------------------------------------------------------
  def update
    @shop_customer = ShopCustomer.find(params[:id])
    if @shop_customer.update_attributes!(params[:shop_customer])
      respond_to do |format|
        flash[:notice] = "Customer updated successfully."
        format.html { redirect_to admin_shop_customers_path }
        format.xml { redirect_to "/admin/shop/customers/#{@shop_customer.id}.xml" }
        format.json { redirect_to "/admin/shop/customers/#{@shop_customer.id}.json" }
      end
    else
      respond_to do |format|
        flash[:error] = "Unable to update new customer."
        format.html { }
        format.xml { render :xml => @shop_customer.errors.to_xml, :status => 422 }
        format.json { render :json => @shop_customer.errors.to_json, :status => 422 }
      end
    end
  end  

  # DELETE /shop/customers/1
  # DELETE /shop/customers/1.xml
  # DELETE /shop/customers/1.json                                  AJAX and HTML
  #----------------------------------------------------------------------------
  def destroy
    # Need to rewrite this method to check for errors and return xml or json.
    # For some reason the answer isn't obvious to me.
    @shop_customer = ShopCustomer.find(params[:id])
    if (@shop_customer && @shop_customer.orders.empty?)
      @shop_customer.destroy   
      respond_to do |format|
        flash[:notice] = "Customer deleted successfully."
        format.html { redirect_to admin_shop_customers_path }
        format.xml  { render :xml => {:message => "Customer deleted successfully."}, :status => 200 }
        format.json  { render :json => {:message => "Customer deleted successfully."}, :status => 200 }
      end
    else
      respond_to do |format|
        flash[:error] = "Unable to delete customer."
        format.html { redirect_to admin_shop_customers_path }
        format.xml  { render :xml => {:message => "Unable to delete customer."}, :status => 422 }
        format.json  { render :json => {:message => "Unable to delete customer."}, :status => 422 }
      end
    end
  end  

end
