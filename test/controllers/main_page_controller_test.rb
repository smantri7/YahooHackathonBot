require 'test_helper'

class MainPageControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get main_page_top_url
    assert_response :success
  end

  test "should get index" do
    get main_page_index_url
    assert_response :success
  end

end
