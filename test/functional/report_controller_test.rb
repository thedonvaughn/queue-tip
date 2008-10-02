require 'test_helper'

class ReportControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end

  def test_can_get_queue_report
    get :queue_report, :date => { "start(2i)" =>  9, "start(3i)" => 8, "start(1i)" => 2008, "end(2i)" => 9, "end(3i)" => 8, "end(1i)" => 2008 }
    assert_response :success
  end

  def test_can_get_full_report
    get :full_report, :date => { "start(2i)" =>  9, "start(3i)" => 8, "start(1i)" => 2008, "end(2i)" => 9, "end(3i)" => 8, "end(1i)" => 2008 }
    assert_response :success
  end

  def test_can_get_agent_report
    get :agent_report, :date => { "start(2i)" =>  9, "start(3i)" => 8, "start(1i)" => 2008, "end(2i)" => 9, "end(3i)" => 8, "end(1i)" => 2008 }, :agent => { :id => 2 }
    assert_response :success
  end

  def test_can_get_group_report
    get :group_report, :date => { "start(2i)" =>  9, "start(3i)" => 8, "start(1i)" => 2008, "end(2i)" => 9, "end(3i)" => 8, "end(1i)" => 2008 }, :group => { :name => "Support" }
    assert_response :success
  end

end
