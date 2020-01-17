require 'test_helper'

class DemandesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get demandes_index_url
    assert_response :success
  end

  test "should get show" do
    get demandes_show_url
    assert_response :success
  end

  test "should get new" do
    get demandes_new_url
    assert_response :success
  end

  test "should get create" do
    get demandes_create_url
    assert_response :success
  end

  test "should get edit" do
    get demandes_edit_url
    assert_response :success
  end

  test "should get update" do
    get demandes_update_url
    assert_response :success
  end

  test "should get destroy" do
    get demandes_destroy_url
    assert_response :success
  end

end
