require 'test_helper'

class StartControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end

  def test_should_get_index
    get :index
    assert_response :success
  end

end
