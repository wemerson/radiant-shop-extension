class AddReferenceAndOrganizationToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :reference, :string
    add_column :users, :organization, :string
  end

  def self.down
    remove_column :users, :reference
    remove_column :users, :organization
  end
end
