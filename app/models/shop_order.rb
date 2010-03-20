class ShopOrder < ActiveRecord::Base
  has_many :payments, :class_name => 'ShopPayment', :dependent => :destroy
  has_many :line_items, :class_name => 'ShopLineItem', :dependent => :destroy, :foreign_key => 'order_id'
  belongs_to :customer, :class_name => 'ShopCustomer'
  #has_and_belongs_to_many :products, :class_name => 'ShopProduct', :join_table => 'orders_products'

  accepts_nested_attributes_for :line_items, :allow_destroy => true, :reject_if => :all_blank

	validates_associated :customer

  def sub_total
    sub_total = 0
    self.line_items.each do |item|
      sub_total += item.total
    end
    sub_total
  end

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
