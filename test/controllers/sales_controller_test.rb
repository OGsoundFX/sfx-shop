require 'test_helper'

class SalesControllerTest < ActionDispatch::IntegrationTest
  test "unauthenticated users cannot create sales" do
    assert_no_difference "Sale.count" do
      post sales_path, params: { sale: { title: "Free packs", percentage: 100 } }
    end

    assert_redirected_to root_path
  end

  test "non-admin users cannot create sales" do
    user = User.create!(email: "sales-user@example.com", password: "password")
    sign_in user

    assert_no_difference "Sale.count" do
      post sales_path, params: { sale: { title: "Free packs", percentage: 100 } }
    end

    assert_redirected_to root_path
  end

  test "admins can create valid sales" do
    user = User.create!(email: "sales-admin@example.com", password: "password", admin: true)
    sign_in user

    assert_difference "Sale.count", 1 do
      post sales_path, params: {
        sale: {
          title: "Summer sale",
          percentage: 100,
          start_date: Date.current,
          end_date: Date.current + 1.day,
          packs: ["All"]
        }
      }
    end

    assert_redirected_to list_sales_path
  end
end
