class Product < ActiveRecord::Base
	belongs_to :category
	has_many :product_images, :dependent => :destroy, :conditions => [ 'parent_id IS NULL' ]
	
	validates_presence_of :title
	validates_numericality_of :price, :greater_than => 0.00, :allow_nil => true

	before_save :reconcile_sequence_numbers

	def to_param
		"#{self.id}-#{self.title.gsub(/[^A-Za-z\-]/,'-').gsub(/-+/,'-')}"
	end

	def url
		"#{self.category.url}/#{self.to_param}"
	end

	def layout
		self.category.product_layout
	end

	def custom=(values)
		values.each do |key, value|
			self.json_field_set(key, value)
		end
	end

private
	def reconcile_sequence_numbers
		if self.sequence.nil? then
			# Assign a new sequence number
			self.sequence=Product.maximum(:sequence, :conditions => { :category_id => self.category_id }).to_i + 1
		else
			if Product.find(:first, :conditions => { :sequence => self.sequence, :category_id => self.category_id }) then
				# We need to reorder the sequences ahead of us
				conditions=[]
				if self.category_id.nil? then
					conditions[0]='category_id IS NULL'
				else
					conditions[0]='category_id = ?'
					conditions << self.category_id
				end
				conditions[0] << ' AND sequence >= ?'
				conditions << self.sequence

				conflicts=Product.find(:all, :conditions => conditions, :order => 'sequence ASC')
				conflicts.each_with_index do |c, idx|
					Product.update_all("sequence=#{self.sequence + idx + 1}","id=#{c.id}")
				end
			end
		end
	end
end
