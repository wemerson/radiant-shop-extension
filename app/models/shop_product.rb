class ShopProduct < ActiveRecord::Base
	belongs_to :category, :class_name => 'ShopCategory'
  has_and_belongs_to_many :orders, :class_name => 'ShopOrder'

	has_many :images, :through => :product_images, :order => 'product_images.position ASC', :uniq => :true
	
	validates_presence_of :title
	validates_uniqueness_of :title
	validates_presence_of :sku
  validates_uniqueness_of :sku
	validates_presence_of :handle
  validates_uniqueness_of :handle
	validates_numericality_of :price, :greater_than => 0.00, :allow_nil => true

	before_save :reconcile_sequence_numbers
	after_save :resequence_all

  def to_param
    self.title.downcase.gsub(/[^A-Za-z\-]/,'_').gsub(/-+/,'_')
  end
  
  def url
    "product/#{self.to_param}"
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
			# Reorder everything and assign a new sequence number
			resequence_all(self)
			self.sequence=ShopProduct.maximum(:sequence, :conditions => { :category_id => self.category_id }).to_i + 1
		else
			if ShopProduct.find(:first, :conditions => { :sequence => self.sequence, :category_id => self.category_id }) then
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

				conflicts=ShopProduct.find(:all, :conditions => conditions, :order => 'sequence ASC')
				conflicts.each_with_index do |c, idx|
					ShopProduct.update_all("sequence=#{self.sequence + idx + 1}","id=#{c.id}")
				end
			end
		end
	end
	
	def resequence_all(prod=nil)
		prod=self if prod.nil?
		ShopProduct.find(:all, :conditions => { :category_id => prod.category_id }, :order => 'sequence ASC').each_with_index do |p, idx|
			ShopProduct.update_all("sequence=#{idx+1}", "id=#{p.id}") unless p.sequence == (idx+1)
		end
		true
	end

end
