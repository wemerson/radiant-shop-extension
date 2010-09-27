class ChangePaymentAddCardTypeCardNumber < ActiveRecord::Migration
  def self.up
    add_column :shop_payments, :card_type, :string
    add_column :shop_payments, :card_number, :string
  end

  def self.down
    remove_column :shop_payments, :card_type
    remove_column :shop_payments, :card_number
  end
end
