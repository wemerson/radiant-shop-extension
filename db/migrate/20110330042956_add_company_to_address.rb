class AddCompanyToAddress < ActiveRecord::Migration
  def self.up
    add_column :shop_addresses, :business, :string
  end

  def self.down
  end
end
