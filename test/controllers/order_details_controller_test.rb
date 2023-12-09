require "test_helper"

class OrderDetailsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get order_details_show_url
    assert_response :success
  end
end
