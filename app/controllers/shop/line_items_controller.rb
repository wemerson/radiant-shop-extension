class Shop::LineItemsController < ApplicationController
  no_login_required
  skip_before_filter :verify_authenticity_token
  
  # GET /shop/line_items
  # GET /shop/line_items.js
  # GET /shop/line_items.xml
  # GET /shop/line_items.json                                     AJAX and HTML
  #----------------------------------------------------------------------------
  def index
    @shop_line_items = current_shop_order.line_items.all
    attr_hash =  { 
      :include => :product,
      :only => [:id, :quantity] 
    }
        
    respond_to do |format|
      format.html { render }
      format.js { render :partial => '/shop/line_items/excerpt', :collection => @shop_line_items }
      format.json { render :json => @shop_line_items.to_json(attr_hash) }
      format.xml { render :xml => @shop_line_items.to_xml(attr_hash) }
    end
  end
  
  # GET /shop/line_items/1
  # GET /shop/line_items/1.js
  # GET /shop/line_items/1.xml
  # GET /shop/line_items/1.json                                   AJAX and HTML
  #----------------------------------------------------------------------------
  def show
    @shop_line_item = current_shop_order.line_items.find(params[:id])
    attr_hash =  {
      :include => :product,
      :only => [:id, :quantity]
    }
    
    respond_to do |format|
      format.html { render }
      format.js { render :partial => '/shop/line_items/line_item', :locals => { :line_item => @shop_line_item } }
      format.xml { render :xml => @shop_line_item.to_xml(attr_hash) }
      format.json { render :json => @shop_line_item.to_json(attr_hash) }
    end
  end
  
  # POST /shop/line_items/1
  # POST /shop/line_items/1.js
  # POST /shop/line_items/1.xml
  # POST /shop/line_items/1.json                                  AJAX and HTML
  #----------------------------------------------------------------------------
  def create
    if current_shop_order.add(params[:shop_line_item][:product_id], params[:shop_line_item][:quantity])
      respond_to do |format|
        format.html { 
          flash[:notice] = "Product added to cart."
          redirect_to :back
        }
        format.js { render :partial => '/shop/line_items/excerpt', :locals => { :excerpt => @shop_line_item } }
        format.xml { redirect_to "/shop/line_items/#{@shop_line_item.id}.xml" }
        format.json { redirect_to "/shop/line_items/#{@shop_line_item.id}.json" }
      end
    else
      respond_to do |format|
        format.html { 
          flash[:error] = "Unable to add product to cart."
          render
        }
        format.js { render :text => @shop_line_item.errors.to_json, :status => :unprocessable_entity }
        format.xml { render :xml => @shop_line_item.errors.to_xml, :status => :unprocessable_entity }
        format.json { render :json => @shop_line_item.errors.to_json, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /shop/line_items/1
  # PUT /shop/line_items/1.js
  # PUT /shop/line_items/1.xml
  # PUT /shop/line_items/1.json                                   AJAX and HTML
  #----------------------------------------------------------------------------
  def update
    if current_shop_order.update(params[:shop_line_item][:product_id], params[:shop_line_item][:quantity])
      respond_to do |format|
        format.html { 
          flash[:notice] = "Line Item updated successfully."
          redirect_to :back
        }
        format.js { render :partial => '/shop/line_item/excerpt', :locals => { :excerpt => @shop_line_item } }
        format.xml { redirect_to "/shop/line_item/#{@shop_line_item.id}.xml" }
        format.json { redirect_to "/shop/line_item/#{@shop_line_item.id}.json" }
      end
    else
      respond_to do |format|
        format.html { 
          flash[:error] = "Unable to update Line Item."
          render
        }
        format.js { render :text => @shop_line_item.errors.to_s, :status => :unprocessable_entity }
        format.xml { render :xml => @shop_line_item.errors.to_xml, :status => :unprocessable_entity }
        format.json { render :json => @shop_line_item.errors.to_json, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /shop/line_items/1
  # DELETE /shop/line_items/1.js
  # DELETE /shop/line_items/1.xml
  # DELETE /shop/line_items/1.json                                AJAX and HTML
  #----------------------------------------------------------------------------
  def destroy
    @shop_line_item = current_shop_order.line_items.find(params[:id])
    @shop_order = @shop_line_item.order

    if @shop_line_item and @shop_line_item.destroy
      @message = "Line Item deleted successfully."

      respond_to do |format|
        format.html {
          flash[:notice] = @message
          redirect_to :back
        }
        format.js { render :text => @message, :status => 200 }
        format.xml { render :xml => {:message => @message}, :status => 200 }
        format.json { render :json => {:message => @message}, :status => 200 }
      end
    else
      @message = "Unable to delete Line Item."

      respond_to do |format|
        format.html {
          flash[:error] = @message
          render
        }
        format.js { render :text => @message, :status => 422 }
        format.xml { render :xml => {:message => @message}, :status => :unprocessable_entity }
        format.json { render :json => {:message => @message}, :status => :unprocessable_entity }
      end
    end
  end
  
end