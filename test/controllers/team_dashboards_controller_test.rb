require "test_helper"

class TeamDashboardsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get team_dashboards_index_url
    assert_response :success
  end
end
