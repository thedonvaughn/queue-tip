require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end

  def test_should_get_index
    get :index
    assert_response :success
  end

  def test_should_get_edit_settings
    get :edit_settings
    assert_response :success
  end

end
