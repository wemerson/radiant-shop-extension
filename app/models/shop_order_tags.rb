module ShopOrderTags
  include Radiant::Taggable
  include ActionView::Helpers::NumberHelper
  
  class ShopOrderTagError < StandardError; end
    
  tag 'shop:order' do |tag|
    tag.locals.shop_order = find_shop_order(tag)
    tag.expand unless tag.locals.shop_order.nil?
  end
  
  [:id, :status].each do |symbol|
    desc %{ outputs the #{symbol} to the products generated page }
    tag "shop:order:#{symbol}" do |tag|
      unless tag.locals.shop_order.nil?
        hash = tag.locals.shop_order
        hash[symbol]
      end
    end
  end
  
  tag 'shop:order:line_items' do |tag|
    tag.expand
  end
  
  tag 'shop:order:line_items:each' do |tag|
    content = ''
    tag.locals.shop_order.line_items.each do |line_item|
      tag.locals.shop_line_item = line_item
      content << tag.expand
    end
    content
  end
  
  tag 'shop:order:line_item' do |tag|
    tag.locals.shop_line_item = find_shop_line_item(tag)
    tag.locals.shop_product = tag.locals.shop_line_item.product
    tag.expand unless tag.locals.shop_line_item.nil?
  end
  
  tag 'shop:order:line_item:quantity' do |tag|
    tag.locals.shop_line_item.quantity
  end
  
  tag 'shop:order:line_item:total_price' do |tag|
    tag.locals.shop_line_item.calc_price
  end
  
  tag 'shop:order:line_item:total_weight' do |tag|
    tag.locals.shop_line_item.calc_weight
  end
  
protected

  def find_shop_order(tag)
    if tag.locals.shop_order
      tag.locals.shop_order
    elsif tag.attr['id']
      ShopOrder.find(tag.attr['id'])
    else
      ShopOrder.find(request.session[:shop_order])
    end
  end

  def find_shop_line_item(tag)
    if tag.locals.shop_line_item
      tag.locals.shop_line_item
    elsif tag.attr['product_id']
      tag.local.shop_order.line_items.find(:first, :conditions => {:product_id => tag.attr['product_id']})
    end
  end

end