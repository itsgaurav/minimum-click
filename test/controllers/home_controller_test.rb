require 'test_helper'
require 'constant'
class HomeControllerTest < ActionController::TestCase
  def setup
    @file = fixture_file_upload('lib/input.txt', 'text/xml')
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should give no file error if no file uploaded" do
    post :upload
    assert response.body.include?(NO_FILE_PROVIDED)
  end

  test "should give error if file format is incorrect" do
    wrong_file = fixture_file_upload('lib/input_wrong.txt', 'text/xml')
    post :upload, :input_data => wrong_file
    assert response.body.include?(ERROR_READING_FILE)
  end

  test "should give correct result for valid input" do
    post :upload, :form_data => @file
    assert response.body.include?("7")
  end

  

end
