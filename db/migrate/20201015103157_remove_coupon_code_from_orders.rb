class RemoveCouponCodeFromOrders < ActiveRecord::Migration[6.0]
  def change
    remove_column :orders, :coupon_code, :string
  end
end
