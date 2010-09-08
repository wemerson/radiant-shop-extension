class CreateSnippets < ActiveRecord::Migration
  def self.up
    Snippet.create({
      :name     => 'CartOverview',
      :content  => <<-BEGIN
<r:shop:cart>
  <r:quantity />
  <r:price />
</r:shop:cart>
BEGIN
    })
  end

  def self.down
  end
end
