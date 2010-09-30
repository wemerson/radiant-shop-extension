module ShopProductHelper
  def input_currency(amount)
    number_to_currency(amount, :unit => '', :delimiter => '')
  end
end