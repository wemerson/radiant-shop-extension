class Admin::Shop::Packages::PackingsController < Admin::ResourceController
  model_class ShopPacking
  
  def sort
    notice = 'Products successfully sorted.'
    
    begin  
      @shop_packings = CGI::parse(params[:packings])["package_products[]"]

      @shop_packings.each_with_index do |id, index|
        ShopPacking.find(id).update_attributes!({ :position, index+1 })
      end
      
      respond_to do |format|
        format.html {
          flash[:notice] = notice
          redirect_to admin_shop_packages_path
        }
        format.js   { render  :text => notice, :status => :ok }
        format.json { render  :json => { :notice => notice }, :status => :ok }
      end
    rescue Exception => e
      error = e
      respond_to do |format|
        format.html {
          flash[:error] = error
          redirect_to admin_shop_packages_path
        }
        format.js   { render  :text => error, :status => :unprocessable_entity }
        format.json { render  :json => { :error => error }, :status => :unprocessable_entity }
      end
    end
  end
  
  def create
    notice = 'Product successfully attached.'
    
    begin
      @shop_packing.package = ShopPackage.find(params[:package_id])
      @shop_packing.product = ShopProduct.find(params[:product_id])
      @shop_packing.save!
      
      respond_to do |format|
        format.js { render :partial => 'admin/shop/packages/edit/product', :locals => { :product => @shop_packing.product, :packing => @shop_packing } }
      end
    rescue Exception => e
      error = e
      respond_to do |format|
        format.js   { render :text  => error, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    notice = 'Product Quantity successfully updated.'
    
    begin
      @shop_packing.update_attributes!({ :quantity => params[:quantity] })
      respond_to do |format|
        format.js   { render :text  => notice, :status => :ok }
      end
    rescue Exception => e
      error = e
      respond_to do |format|
        format.js   { render :text  => error, :status => :unprocessable_entity }
      end
    end
    
  end
  
  def destroy
    notice = 'Product successfully removed.'    
    
    begin
      @shop_product = @shop_packing.product
      @shop_package = @shop_packing.package
      
      @shop_packing.destroy
      
      respond_to do |format|
        format.js { render :partial => 'admin/shop/packages/edit/product', :locals => { :product => @shop_product } }
      end
    rescue Exception => e
      error = e
      respond_to do |format|
        format.js   { render :text  => error, :status => :unprocessable_entity }
      end
    end
  end
  
end