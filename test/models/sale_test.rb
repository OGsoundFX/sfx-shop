require 'test_helper'

class SaleTest < ActiveSupport::TestCase
  test "discount percentage must be between zero and one hundred" do
    assert Sale.new(percentage: 0).valid?
    assert Sale.new(percentage: 100).valid?
    assert_not Sale.new(percentage: -1).valid?
    assert_not Sale.new(percentage: 101).valid?
  end
end
