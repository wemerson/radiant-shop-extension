class ShopVariant < ActiveRecord::Base
  
  belongs_to  :created_by,  :class_name => 'User'
  belongs_to  :updated_by,  :class_name => 'User'
  
  has_many    :categories,  :class_name => 'ShopCategory', :foreign_key => 'variant_id'
  
  validates_presence_of   :name
  validates_uniqueness_of :name
  validates_presence_of   :options_json
  
  def options
    options = {}
    if self.options_json.present?
      result = ActiveSupport::JSON.decode(self.options_json)
      result = Forms::Config.deep_symbolize_keys(options)
    end
    options
  end
  
  def options=(options)
    self.options_json = ActiveSupport::JSON.encode(options)
  end
  
end