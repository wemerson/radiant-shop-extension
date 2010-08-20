class ShopAddressable < ActiveRecord::Base
  
  belongs_to  :address,   :polymorphic => true
  belongs_to  :addresser, :polymorphic => true
  
  validates_presence_of   :address_id
  validates_presence_of   :address_type
  validates_presence_of   :addresser_id
  validates_presence_of   :addresser_type
  
end