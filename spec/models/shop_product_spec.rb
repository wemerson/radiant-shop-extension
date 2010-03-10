require File.dirname(__FILE__) + '/../spec_helper'

describe ShopProduct do
  before(:each) do
    Category.destroy_all
    Product.destroy_all

    c=Category.create!(:title => 'My Little Test Category')
    c2=Category.create!(:title => 'Another Test Category')
    @product = Product.new(:title => 'Test', :category => c)
  end

  it "should be valid" do
    @product.should be_valid
  end

  describe "instance" do
    before do
      @product.save
    end

    it "should generate a valid parameter string" do
      @product.to_param.should =~ /^\d+-[A-Za-z0-9\-]+/
    end

    it "should generate a valid url" do
      @product.url.should == "#{@product.category.url}/#{@product.to_param}"
    end
  end

  describe "sequencing" do
    before do
      @p1=@product.clone
      @p1.title='Alpha'
      @p2=@product.clone
      @p2.title='Bravo'
      @p3=@product.clone
      @p3.title='Charlie'
      @p1.save!; @p2.save!; @p3.save!
      @sp1=@product.clone
      @sp1.category=Category.find_all_except(@p1.category).first
      @sp1.save!
    end

    it "should assign sequences by default" do
      @p1.sequence.should == 1
      @p2.sequence.should == 2
      @p3.sequence.should == 3
      # Sequence should be scoped to category_id
      @sp1.sequence.should == 1
    end

    it "should resolve conflicting sequences" do
      p4=@product.clone
      p4.title='Delta'
      p4.sequence=2
      p4.save
      @p1.reload; @p2.reload; @p3.reload; @sp1.reload
      @p1.sequence.should == 1
      p4.sequence.should == 2
      @p2.sequence.should == 3
      @p3.sequence.should == 4
      # Sequence should not be messed with for separate category_ids
      @sp1.sequence.should == 1
    end

    it "should not regenerate on deletion" do
      @p2.destroy
      @p1.reload; @p3.reload; @sp1.reload
      @p1.sequence.should == 1
      @p3.sequence.should == 3
      # Sequence should not be messed with for separate category_ids
      @sp1.sequence.should == 1
    end

    it "should regenerate to fill gaps on next creation" do
      @p2.destroy
      p4=@product.clone
      p4.title='Delta'
      p4.save
      @p1.reload; @p3.reload; @sp1.reload
      @p1.sequence.should == 1
      @p3.sequence.should == 2
      p4.sequence.should == 3
      # Sequence should not be messed with for separate category_ids
      @sp1.sequence.should == 1
    end
  end
end
