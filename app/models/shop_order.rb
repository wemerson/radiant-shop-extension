class ShopOrder < ActiveRecord::Base
  has_many :payments, :class_name => 'ShopPayment', :dependent => :destroy, :foreign_key => 'order_id'
  has_many :line_items, :class_name => 'ShopLineItem', :dependent => :destroy, :foreign_key => 'order_id'
  has_many :products, :class_name => 'ShopProduct', :through => :line_items, :foreign_key => 'product_id'
  belongs_to :customer, :class_name => 'ShopCustomer'

  accepts_nested_attributes_for :line_items, :allow_destroy => true, :reject_if => :all_blank
  accepts_nested_attributes_for :payments, :allow_destroy => true, :reject_if => :all_blank

  validates_associated :customer

  class << self

    def search(search, filter, page)
      unless search.blank?

        search_cond_sql = []
        search_cond_sql << 'LOWER(status) LIKE (:term)'
        cond_sql = search_cond_sql.join(" OR ")

        @conditions = [cond_sql, {:term => "%#{search.downcase}%" }]
      else
        @conditions = []
      end

      options = { :conditions => @conditions,
                  :order => 'created_at DESC',
                  :page => page,
                  :per_page => 10 }

      ShopOrder.paginate(:all, options)
    end
    
  end
  
end
