class ShopCustomer < User
  has_many :orders, :class_name => 'ShopOrder', :foreign_key => :customer_id
  has_many :addresses, :class_name => 'ShopAddress', :foreign_key => :customer_id

  accepts_nested_attributes_for :orders, :allow_destroy => true
  accepts_nested_attributes_for :addresses, :allow_destroy => true, :reject_if => :all_blank

  def first_name
    self.name.split(" ")[0]
  end

  def last_name
    self.name.split(" ")[1]
  end

  class << self
    def search(search, filter, page)
      unless search.blank?

        search_cond_sql = []
        search_cond_sql << 'LOWER(name) LIKE (:term)'
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
