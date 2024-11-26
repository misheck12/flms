require "test_helper"

class AdminDashboardsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_dashboards_index_url
    assert_response :success
  end
end
