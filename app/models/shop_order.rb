class ShopOrder < ActiveRecord::Base
  has_many :payments, :class_name => 'ShopPayment'
  belongs_to :customer, :class_name => 'ShopCustomer'
  has_and_belongs_to_many :products, :class_name => 'ShopProduct', :join_table => 'orders_products'

	validates_associated :products, :customer

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
