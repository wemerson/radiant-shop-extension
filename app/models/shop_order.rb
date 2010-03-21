class ShopOrder < ActiveRecord::Base
  has_many :payments, :class_name => 'ShopPayment', :dependent => :destroy, :foreign_key => 'order_id'
  has_many :line_items, :class_name => 'ShopLineItem', :dependent => :destroy, :foreign_key => 'order_id'
  belongs_to :customer, :class_name => 'ShopCustomer'

  accepts_nested_attributes_for :line_items, :allow_destroy => true, :reject_if => :all_blank
  accepts_nested_attributes_for :payments, :allow_destroy => true, :reject_if => :all_blank

	validates_associated :customer

  def balance
    # Add up all payments
    total_payments = 0
    unless self.payments.empty?
      self.payments.each do |payment|
        total_payments += payment.amount
      end
    end

    order_total = self.sub_total # After we add taxes,etc we'll need to update this to sub_total + taxes + shipping
    (order_total - total_payments)
  end

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
