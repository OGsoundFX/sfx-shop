class AddCouponCodeToDiscounts < ActiveRecord::Migration[6.0]
  def change
    add_column :discounts, :coupon_code, :string
  end
end
