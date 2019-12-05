require 'test_helper'

class DonvertControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get donvert_new_url
    assert_response :success
  end

  test "should get edit" do
    get donvert_edit_url
    assert_response :success
  end

  test "should get create" do
    get donvert_create_url
    assert_response :success
  end

  test "should get index" do
    get donvert_index_url
    assert_response :success
  end

end
