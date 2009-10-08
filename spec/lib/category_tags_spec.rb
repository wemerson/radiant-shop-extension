require File.dirname(__FILE__) + '/../spec_helper'

describe 'SimpleProductManager' do
	dataset :pages
	dataset :products

	describe '<r:category:find>' do
		it "should use 'where' option correctly" do
			pages(:home).should render('<r:category:find where="title=\'Bread\'"><r:category:title /></r:category:find>').as('Bread')
		end
		it "should use 'tag' option correctly" do
			pages(:home).should render('<r:category:find tag="Retail"><r:category:title /></r:category:find>').as('Pastries')
		end
		it "should use 'tag' and 'where' options simultaniously correctly" do
			pages(:home).should render('<r:category:find tag="Gluten Free" where="title=\'Salads\'"><r:category:title /></r:category:find>').as('Salads')
		end
	end
	
	describe '<r:categories:each>' do
		it "should itterate over every top-level category by default" do
			# We have 3 top-level categories - one dot for each one
			pages(:home).should render('<r:categories:each>.</r:categories:each>').as('...')
		end
		
		it "should order by sequence by default" do
			Category.find_by_title('Bread').update_attribute(:sequence, 5)
			Category.find_by_title('Salads').update_attribute(:sequence, 10)
			Category.find_by_title('Pastries').update_attribute(:sequence, 20)
			pages(:home).should render('<r:categories:each><r:category:title />,</r:categories:each>').as('Bread,Salads,Pastries,')
		end

		it "should order OK by title" do
			pages(:home).should render('<r:categories:each order="title DESC"><r:category:title />,</r:categories:each>').as('Salads,Pastries,Bread,')
		end
				
		it "should restrict OK by title" do
			pages(:home).should render('<r:categories:each where="title=\'Bread\'"><r:category:title /></r:categories:each>').as('Bread')
		end

		it "should restrict OK by tags" do
			pages(:home).should render('<r:categories:each tag="Gluten Free"><r:category:title /><br /></r:categories:each>').as('Salads<br />Pastries<br />')
		end

		it "should restrict OK by tags with ordering" do
			pages(:home).should render('<r:categories:each tag="Gluten Free" order="title DESC"><r:category:title /><br /></r:categories:each>').as('Salads<br />Pastries<br />')
		end

		it "should restrict OK by parent id" do
			c=Category.find_by_title('Bread')
			pages(:home).should render("<r:categories:each parent=\"#{c.id}\" order=\"title ASC\"><r:category:title /><br /></r:categories:each>").as('Sourdough Breads<br />Spelt Breads<br />Wholemeal Breads<br />')
		end

		it "should restrict OK by parent title" do
			pages(:home).should render("<r:categories:each parent=\"Bread\" order=\"title ASC\"><r:category:title /><br /></r:categories:each>").as('Sourdough Breads<br />Spelt Breads<br />Wholemeal Breads<br />')
		end
	end
	
	%w(id title description).each do |type|
		describe "<r:category:#{type}>" do
			it "should work inside of categories:each" do
				pages(:home).should render("<r:categories:each order=\"id\"><r:category:#{type} />,</r:categories:each>").as(Category.find_all_top_level.collect { |p| p.send(type.to_sym) }.join(',') + ',')
			end
			
			it "should work inside of category" do
				pages(:home).should render("<r:category:find where=\"title='Bread'\"><r:category:#{type} /></r:category:find>").as(Category.find_by_title('Bread').send(type.to_sym).to_s)
			end
		end
	end

	describe "<r:category:link>" do
		before do
			@c=Category.find(:first)
		end

		it "should work inside of category:find" do
			pages(:home).should render("<r:category:find where=\"id=#{@c.id}\"><r:category:link><r:category:title /></r:category:link></r:category:find>").as("<a href=\"#{@c.url}\">#{@c.title}</a>")
		end
		it "should default to the title if no content" do
			pages(:home).should render("<r:category:find where=\"id=#{@c.id}\"><r:category:link /></r:category:find>").as("<a href=\"#{@c.url}\">#{@c.title}</a>")
		end
		it "should work inside of categories:each" do
			pages(:home).should render("<r:categories:each where=\"id=#{@c.id}\"><r:category:link><r:category:title /></r:category:link></r:categories:each>").as("<a href=\"#{@c.url}\">#{@c.title}</a>")
		end

		it "should set a class when the current page" do
			c=Category.find(:first)
			url=c.url
			page=RailsPage.new(:title => 'Category Test', :url => url)
			page.should render("<r:category:find where=\"id=#{c.id}\"><r:category:link><r:category:title /></r:category:link></r:category:find>").as("<a href=\"#{url}\" class=\"current\">#{c.title}</a>")
		end

		it "should set a custom class when provided and selected" do
			c=Category.find(:first)
			url=c.url
			page=RailsPage.new(:title => 'Category Test', :url => url)
			page.should render("<r:category:find where=\"id=#{c.id}\"><r:category:link selected=\"hilight\"><r:category:title /></r:category:link></r:category:find>").as("<a href=\"#{url}\" class=\"hilight\">#{c.title}</a>")
		end
	end
	
	describe "<r:category:field>" do
		before do
			@c=Category.find(:first)
			@c.json_field_set(:fieldname, "Foo")
			@c.save!
		end

		it "should fetch existing data OK" do
			pages(:home).should render("<r:category:find where=\"id='#{@c.id}'\"><r:category:field name=\"fieldname\" /></r:category:find>").as("Foo")
		end

		it "should return nothing on missing data" do
			pages(:home).should render("<r:category:find where=\"id='#{@c.id}'\">-<r:category:field name=\"different_name\" />-</r:category:find>").as("--")
		end
	end

	describe "<r:category:if>" do
		it "should match by title" do
			pages(:home).should render('<r:categories:each order="title ASC"><r:category:if title="Pastries"><r:category:title /></r:category:if></r:categories:each>').as('Pastries')
		end
		it "should match by id" do
			p=Category.find_by_title('Pastries')
			pages(:home).should render("<r:categories:each order=\"title ASC\"><r:category:if id=\"#{p.id}\"><r:category:title /></r:category:if></r:categories:each>").as('Pastries')
		end
		it "should match within find" do
			p=Category.find_by_title('Pastries')
			pages(:home).should render("<r:category:find where=\"id=#{p.id}\"><r:category:if id=\"#{p.id}\"><r:category:title /></r:category:if></r:category:find>").as('Pastries')
		end
		it "should suppress content when no match within find" do
			p=Category.find_by_title('Pastries')
			pages(:home).should render("<r:category:find where=\"id=#{p.id}\">-<r:category:if title=\"Something Different\"><r:category:title /></r:category:if>-</r:category:find>").as('--')
		end
	end

	describe "<r:category:unless>" do
		it "should match by title" do
			pages(:home).should render('<r:categories:each order="title ASC"><r:category:unless title="Pastries"><r:category:title /></r:category:unless></r:categories:each>').as('BreadSalads')
		end
		it "should match by id" do
			p=Category.find_by_title('Pastries')
			pages(:home).should render("<r:categories:each order=\"title ASC\"><r:category:unless id=\"#{p.id}\"><r:category:title /></r:category:unless></r:categories:each>").as('BreadSalads')
		end
		it "should restrict content when no match within find" do
			p=Category.find_by_title('Pastries')
			pages(:home).should render("<r:category:find where=\"id=#{p.id}\">-<r:category:unless id=\"#{p.id}\"><r:category:title /></r:category:unless>-</r:category:find>").as('--')
		end
		it "should match within find" do
			p=Category.find_by_title('Pastries')
			pages(:home).should render("<r:category:find where=\"id=#{p.id}\">-<r:category:unless title=\"Something Different\"><r:category:title /></r:category:unless>-</r:category:find>").as('-Pastries-')
		end
	end

	describe "<r:category:if_self>" do
		before do
			@category=Category.find(:first)
			@page=RailsPage.new(:class_name => "RailsPage", :slug => @category.url)
		end
		it "should expand on the relevant page" do
			# Sometimes there is a trailing slash from the page.url. Remove it before we check.
			@page.url.gsub(/\/$/,'').should == @category.url
			@page.should render("<r:categories:each><r:category:if_self><r:title /></r:category:if_self></r:categories:each>").as(@category.title)
		end
	end
	describe "<r:category:unless_self>" do
		before do
			@category=Category.find(:first)
			@page=RailsPage.new(:class_name => "RailsPage", :slug => @category.url)
		end
		it "should expand on the relevant page" do
			# Sometimes there is a trailing slash from the page.url. Remove it before we check.
			@page.url.gsub(/\/$/,'').should == @category.url
			@page.should render("<r:categories:each order=\"title ASC\"><r:category:unless_self><r:title /></r:category:unless_self></r:categories:each>").as(Category.find(:all, :conditions => [ 'id != ? AND parent_id IS NULL', @category.id], :order => 'title ASC').collect { |c| c.title }.join(''))
		end
	end
end
