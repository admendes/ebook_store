require "test_helper"

class EbooksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get ebooks_index_url
    assert_response :success
  end

  test "should get show" do
    get ebooks_show_url
    assert_response :success
  end

  test "should get new" do
    get ebooks_new_url
    assert_response :success
  end

  test "should get edit" do
    get ebooks_edit_url
    assert_response :success
  end
end
