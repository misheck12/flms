require "test_helper"

class RefereeDashboardsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get referee_dashboards_index_url
    assert_response :success
  end
end
