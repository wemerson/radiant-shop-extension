class Shop::LineItemsController < ApplicationController
  
  no_login_required
  skip_before_filter :verify_authenticity_token
  
  # GET /shop/line_items
  # GET /shop/line_items.js
  # GET /shop/line_items.json                                     AJAX and HTML
  #----------------------------------------------------------------------------
  def index
    attr_hash = { 
      :include  => :product,
      :only     => ShopLineItem.params
    }
    
    @shop_line_items = find_or_create_shop_order.line_items.all
        
    respond_to do |format|
      format.html { render :index }
      format.js   { render :partial => '/shop/line_items/line_item', :collection => @shop_line_items }
      format.json { render :json    => @shop_line_items.to_json(attr_hash) }
    end
  end
  
  # GET /shop/line_items/1
  # GET /shop/line_items/1.js
  # GET /shop/line_items/1.json                                   AJAX and HTML
  #----------------------------------------------------------------------------
  def show
    attr_hash = { 
      :include  => :product,
      :only     => ShopLineItem.params
    }
    
    @shop_line_item = find_or_create_shop_order.line_items.find(params[:id])
    
    respond_to do |format|
      format.html { render :show }
      format.js   { render :partial => '/shop/line_items/line_item', :locals => { :line_item => @shop_line_item } }
      format.json { render :json    => @shop_line_item.to_json(attr_hash) }
    end
  end
  
  # POST /shop/line_items/1
  # POST /shop/line_items/1.js
  # POST /shop/line_items/1.xml
  # POST /shop/line_items/1.json                                  AJAX and HTML
  #----------------------------------------------------------------------------
  def create
    notice  = 'Item added to Cart.'
    error   = 'Could not add Item to Cart.'
    
    attr_hash = { 
      :include  => :item,
      :only     => ShopLineItem.params
    } 
    
    begin
      id        = params[:line_item][:item_id]
      type      = params[:line_item][:item_type]
      quantity  = params[:line_item][:quantity]
      
      @shop_line_item = find_or_create_shop_order.add!(id, quantity, type)
      
      respond_to do |format|
        format.html {
          flash[:notice] = notice
          redirect_to :back
        }
        format.js   { render :partial => '/shop/line_items/line_item', :locals => { :line_item => @shop_line_item } }
        format.json { render :json    => @shop_line_item.to_json(attr_hash)  }
      end
    rescue
      respond_to do |format|
        format.html {
          flash[:error] = error
          redirect_to :back
        }
        format.js   { render  :text => error, :status => :unprocessable_entity }
        format.json { render  :json => { :error => error }, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /shop/line_items/1
  # PUT /shop/line_items/1.js
  # PUT /shop/line_items/1.xml
  # PUT /shop/line_items/1.json                                   AJAX and HTML
  #----------------------------------------------------------------------------
  def update
    notice  = 'Item updated successfully.'
    error   = 'Could not update Item.'
    
    attr_hash = { 
      :include  => :product,
      :only     => ShopLineItem.params
    }
    
    begin
      id = params[:id]
      quantity = params[:line_item][:quantity] || 1
      
      @shop_line_item = find_or_create_shop_order.update!(id, quantity)
      
      respond_to do |format|
        format.html {
          flash[:notice] = notice
          redirect_to :back
        }
        format.js   { render :partial => '/shop/line_items/line_item', :locals => { :line_item => @shop_line_item } }
        format.json { render :json    => @shop_line_item.to_json(attr_hash)  }
      end
    rescue
      respond_to do |format|
        format.html {
          flash[:error] = error
          redirect_to :back
        }
        format.js   { render  :text => error, :status => :unprocessable_entity }
        format.json { render  :json => { :error => error }, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /shop/line_items/1
  # DELETE /shop/line_items/1.js
  # DELETE /shop/line_items/1.xml
  # DELETE /shop/line_items/1.json                                AJAX and HTML
  #----------------------------------------------------------------------------
  def destroy
    notice  = 'Item removed from Cart.'
    error   = 'Could not remove Item from Cart.'
    
    begin
      # Expects the product it, not the line item
      find_or_create_shop_order.remove!(params[:id])
      
      respond_to do |format|
        format.html {
          flash[:notice] = notice
          redirect_to :back
        }
        format.js   { render  :text => notice, :status => :ok }
        format.json { render  :json => { :notice => notice }, :status => :ok }
      end
    rescue
      respond_to do |format|
        format.html {
          flash[:error] = error
          redirect_to :back
        }
        format.js   { render  :text => error, :status => :unprocessable_entity }
        format.json { render  :json => { :error => error }, :status => :unprocessable_entity }
      end
    end
  end
  
end
