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
    post :upload, {:input_type => "file"}
    assert response.body.include?(NO_FILE_PROVIDED)
  end

  test "should give error if file format is incorrect" do
    wrong_file = fixture_file_upload('lib/input_wrong.txt', 'text/xml')
    post :upload, {:input_data => wrong_file, :input_type => "file" }
    assert response.body.include?(ERROR_READING_FILE)
  end

  test "should give correct result for valid file input" do
    post :upload, {:form_data => @file, :input_type => "file" }
    assert response.body.include?("7")
  end

  test "should give error if wrong input provided" do
    post :upload, {:low_ch=>"sds", :high_ch=>"dssd", :input_type=>"html"}
    assert response.body.include?(INCORRECT_DATA)
  end

  test "should give correct result for valid html input" do
    post :upload, {:low_ch=>1, :high_ch=>20, :blocked_list => "18 19", :view_sequence => "15 14 17 1 17", :input_type=>"html"}
    assert response.body.include?("7")
  end
end
