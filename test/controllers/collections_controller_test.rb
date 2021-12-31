require 'test_helper'

class CollectionsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get collections_create_url
    assert_response :success
  end

end
