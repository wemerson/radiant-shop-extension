require File.dirname(__FILE__) + '/../spec_helper'

describe ProductImage do
	before(:each) do
		category=Category.create(:title => 'Test Category')
		@product=Product.create(:title => 'Test', :category => category)
		@product_image=@product.product_images.new(:description => 'Foo', :filename => "foo.jpg", :content_type => 'images/jpeg', :size => 100)
	end

	it "should be valid" do
		@product_image.should be_valid
	end

	it "should respond to description" do
		@product_image.description.should == 'Foo'
	end

	it "should set tags for DB in correct format from tag_names" do
		@product_image.tag_names='Foo, Bar'
		@product_image.tags.should == ',Foo,Bar,'
		@product_image.tag_names='Bletch Blomb'
		@product_image.tags.should == ',Bletch Blomb,'
		@product_image.tag_names=[ 'Foo', 'Bar', 'Bletch Blomb' ]
		@product_image.tags.should == ',Foo,Bar,Bletch Blomb,'
		@product_image.tag_names=''
		@product_image.tags.should == ''
		@product_image.tag_names=nil
		@product_image.tags.should == ''
	end

	it "should return tags in human format from tag_names" do
		@product_image.tags=',Foo,Bar,Bletch Blomb,'
		@product_image.tag_names.should == 'Foo, Bar, Bletch Blomb'
		@product_image.tags=nil
		@product_image.tag_names.should == ''
	end

	describe "saved instance" do
		before do
			@product_image.save!
		end

		it "should respond to the attachment_fu methods" do
			@product_image.public_filename.should =~ /product_images\/\d+\/\d+\/foo\.jpg/
			@product_image.public_filename(:thumbnail).should =~ /product_images\/\d+\/\d+\/foo_thumbnail\.jpg/
			@product_image.filename.should == 'foo.jpg'
		end

		it "should respond to our url helper method" do
			@product_image.url.should =~ /product_images\/\d+\/\d+\/foo_product\.jpg/
			PRODUCT_ATTACHMENT_SIZES.keys.each do |size|
				@product_image.url(size).should =~ /product_images\/\d+\/\d+\/foo_#{size}\.jpg/
			end
			@product_image.url(:fullsize).should =~ /product_images\/\d+\/\d+\/foo\.jpg/
		end

		describe "tag helper method" do
			it "should render tag with with defaults" do
				@product_image.tag.should == "<img src=\"#{@product_image.url}\" alt=\"Foo\" />"
			end

			it "should render tag with with options" do
				@product_image.tag(:width => 120, :height => 90, :alt => 'BletchBang').should == "<img src=\"#{@product_image.url}\" alt=\"BletchBang\" height=\"90\" width=\"120\" />"
			end

			PRODUCT_ATTACHMENT_SIZES.keys.each do |size|
				it "should render tag for '#{size}' size" do
					@product_image.tag(:type => size).should == "<img src=\"#{@product_image.url(size)}\" alt=\"Foo\" />"
				end

				it "should render tag for size '#{size}' with with options" do
					@product_image.tag(:type => size, :width => 120, :height => 90, :alt => 'BletchBang').should == "<img src=\"#{@product_image.url(size)}\" alt=\"BletchBang\" height=\"90\" width=\"120\" />"
				end
			end

			it "should render tag for fullsize image" do
				@product_image.tag(:type => :fullsize).should == "<img src=\"#{@product_image.url(:fullsize)}\" alt=\"Foo\" />"
			end

			it "should render tag for fullsize image with options" do
				@product_image.tag(:type => :fullsize, :width => 120, :height => 90, :alt => 'BletchBang').should == "<img src=\"#{@product_image.url(:fullsize)}\" alt=\"BletchBang\" height=\"90\" width=\"120\" />"
			end
		end
	end
	
	describe "sequencing" do
		before do
			@product_image=@product.product_images.new(:description => 'Foo', :filename => "foo.jpg", :content_type => 'images/jpeg', :size => 100)

			@i1=@product_image.clone
			@i1.description='Alpha'
			@i1.filename='alpha.jpg'

			@i2=@product_image.clone
			@i2.description='Bravo'
			@i2.filename='bravo.jpg'

			@i3=@product_image.clone
			@i3.description='Charlie'
			@i3.filename='charlie.jpg'

			@i1.save!; @i2.save!; @i3.save!

			@si1=@product_image.clone
			p=Product.create(:title => "Another Product", :category => Category.find(:first))
			@si1.product=Product.find(:first, :conditions => [ 'id != ? ', @i1.product.id ])
			@si1.save!
		end

		it "should assign sequences by default" do
			@i1.sequence.should == 1
			@i2.sequence.should == 2
			@i3.sequence.should == 3
			# Sequence should be scoped to product_id
			@si1.sequence.should == 1
		end

		it "should resolve conflicting sequences" do
			i4=@product_image.clone
			i4.description='Delta'
			i4.filename='delta.jpg'
			i4.sequence=2
			i4.save
			@i1.reload; @i2.reload; @i3.reload; @si1.reload
			@i1.sequence.should == 1
			i4.sequence.should == 2
			@i2.sequence.should == 3
			@i3.sequence.should == 4
			# Sequence should not be messed with for separate product_ids
			@si1.sequence.should == 1
		end

		it "should not regenerate on deletion" do
			@i2.destroy
			@i1.reload; @i3.reload; @si1.reload
			@i1.sequence.should == 1
			@i3.sequence.should == 3
			# Sequence should not be messed with for separate product_ids
			@si1.sequence.should == 1
		end

		it "should regenerate to fill gaps on next creation" do
			@i2.destroy
			i4=@product_image.clone
			i4.description='Delta'
			i4.filename='delta.jpg'
			i4.save
			@i1.reload; @i3.reload; @si1.reload
			@i1.sequence.should == 1
			@i3.sequence.should == 2
			i4.sequence.should == 3
			# Sequence should not be messed with for separate product_ids
			@si1.sequence.should == 1
		end
	end
end
