class ShopVariant < ActiveRecord::Base
  
  validates_presence_of   :name
  validates_uniqueness_of :name
  validates_presence_of   :options
  
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