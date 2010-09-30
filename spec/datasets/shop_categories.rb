class ShopCategoriesDataset < Dataset::Base
  
  uses :shop_variants
  
  def load
    categories = [:bread, :milk, :salad]
    
    categories.each_with_index do |category, i|
      create_record :shop_category, category,
        :name       => category.to_s,
        :handle     => category.to_s,
        :position   => i + 1,
        :variant_id => shop_variants("#{category.to_s}_states".to_sym)
    end
    
  end
end
