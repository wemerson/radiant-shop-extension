class ShopCategoriesDataset < Dataset::Base
  def load
    categories = [:bread, :milk, :salad]
    
    categories.each_with_index do |category, i|
      create_record :shop_category, category,
        :name     => category.to_s,
        :handle   => category.to_s,
        :position => i + 1
    end
    
  end
end
