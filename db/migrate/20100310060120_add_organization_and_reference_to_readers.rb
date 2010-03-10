class AddOrganizationAndReferenceToReaders < ActiveRecord::Migration
  def self.up
    add_column :readers, :reference, :string
    add_column :readers, :organization, :string
  end

  def self.down
    remove_column :readers, :reference
    remove_column :readers, :organization
  end
end
