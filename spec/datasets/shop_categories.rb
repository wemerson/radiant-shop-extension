class ShopCategoriesDataset < Dataset::Base
  
  uses :shop_variants
  
  def load
    categories = [:bread, :milk, :salad]
    
    create_record :layout, 'category',
      :name => 'category'
    
    create_record :layout, 'product',
      :name => 'product'
    
    categories.each_with_index do |category, i|
      create_record :shop_category, category,
        :name       => category.to_s,
        :handle     => category.to_s,
        :position   => i + 1,
        :variant_id => shop_variants("#{category.to_s}_states".to_sym),
        :layout_id  => Layout.first,
        :product_layout_id => Layout.first
    end
    
  end
end
