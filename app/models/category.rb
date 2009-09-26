class Category < ActiveRecord::Base
	has_many :products, :dependent => :destroy
	belongs_to :parent, :class_name => 'Category'
	has_many :subcategories, :class_name => 'Category', :foreign_key => :parent_id, :order => 'sequence ASC'

	validates_presence_of :title

	before_save :reconcile_sequence_numbers
	after_save :resequence_all

	def to_s
		o=[]
		o << self.parent.to_s unless self.parent.nil?
		o << self.title
		o.join(' > ')
	end

	def to_param
		"#{self.id}-#{self.title.gsub(/[^A-Za-z\-]/,'-').gsub(/-+/,'-')}"
	end

	def url
		"/products/#{to_param}"
	end

	def layout
		if !custom_layout.blank? then
			custom_layout
		else
			if self.parent_id.nil? then
				# Use the default
				Radiant::Config['simple_product_manager.category_layout'] || 'Category'
			else
				self.parent.layout
			end
		end
	end

	def product_layout
		if !custom_product_layout.blank? then
			custom_product_layout
		else
			if self.parent_id.nil? then
				# use the default
				Radiant::Config['simple_product_manager.product_layout'] || 'Product'
			else
				self.parent.product_layout
			end
		end
	end

	def tag_names
		return '' if self.tags.blank?
		a=self.tags
		a.split(',').compact.reject { |x| x.blank? }.join(', ')
	end

	def tag_names=(new_tags)
		case new_tags
			when Array
				# NOTE: Surrounding commas are important!
				setter=",#{new_tags.join(',')},"
			when String
				set=new_tags.split(/,/)
				list=set.collect { |x| x.strip }
				# NOTE: Surrounding commas are important!
				setter=",#{list.join(',')},"
			when NilClass
				setter=''
			else
				raise ArgumentError, "Don't know how to handle #{new_tags.class.name}"
		end

		setter='' if setter == ',,'
		self.tags=(setter)
	end

	def custom=(values)
		values.each do |key, value|
			self.json_field_set(key, value)
		end
	end

	def self.find_all_except(c, options={})
		options[:order] ||= 'sequence ASC'
		options[:conditions]=[ 'id != ?', c.id ] unless (c.blank? || c.new_record? )
		self.find(:all, options)
	end

	def self.find_all_top_level(options={})
		options[:order] ||= 'sequence ASC'
		if options[:conditions] then
			options[:conditions]=[options[:conditions]] if !options[:conditions].is_a?(Array)
			options[:conditions][0]="(#{options[:conditions][0]}) AND parent_id IS NULL"
		else
			options[:conditions]="parent_id IS NULL"
		end
		self.find(:all, options)
	end

private
	def reconcile_sequence_numbers
		if self.sequence.nil? then
			# Reorder everything and assign a new sequence number
			resequence_all(self)
			self.sequence=Category.maximum(:sequence, :conditions => { :parent_id => self.parent_id }).to_i + 1
		else
			if Category.find(:first, :conditions => { :sequence => self.sequence, :parent_id => self.parent_id }) then
				# We need to reorder the sequences ahead of us
				conditions=conditions_for_category_matches(self)
				conditions[0] << ' AND sequence >= ?'
				conditions << self.sequence

				conflicts=Category.find(:all, :conditions => conditions, :order => 'sequence ASC')
				conflicts.each_with_index do |c, idx|
					Category.update_all("sequence=#{self.sequence + idx + 1}","id=#{c.id}")
				end
			end
		end
	end

	def resequence_all(cat=nil)
		cat=self if cat.nil?
		Category.find(:all, :conditions => { :parent_id => cat.parent_id }, :order => 'sequence ASC').each_with_index do |c, idx|
			Category.update_all("sequence=#{idx+1}", "id=#{c.id}") unless c.sequence == (idx + 1)
		end
		true
	end

	def conditions_for_category_matches(category)
		conditions=[]
		if category.parent_id.nil? then
			conditions[0]='parent_id IS NULL'
		else
			conditions[0]='parent_id = ?'
			conditions << category.parent_id
		end
		conditions
	end

end
