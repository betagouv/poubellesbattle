require 'test_helper'

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get notifications_index_url
    assert_response :success
  end

  test "should get show" do
    get notifications_show_url
    assert_response :success
  end

  test "should get new" do
    get notifications_new_url
    assert_response :success
  end

  test "should get create" do
    get notifications_create_url
    assert_response :success
  end

end
