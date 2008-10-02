require 'test_helper'

class CallTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end

  def test_have_a_call
    call = Call.find(calls(:one))
    assert call.kind_of?(Call), "No call can be found!"
  end

  def test_call_has_a_caction
    call = Call.find(calls(:two))
    assert call.kind_of?(Call), "No call can be found!"
    caction = call.cactions.first
    assert caction.kind_of?(Caction), "No caction belongs to call!"
  end

  def test_call_belongs_to_an_agent
    call = Call.find(calls(:one))
    assert call.kind_of?(Call), "No call can be found!"
    agent = call.agent
    assert agent.kind_of?(Agent), "This call doesn't belong to an agent!"
  end

  def test_call_belongs_to_a_queue
    call = Call.find(calls(:two))
    assert call.kind_of?(Call), "No call can be found!"
    queue = call.queu
    assert queue.kind_of?(Queu), "This call doesn't belong to a queue!"
  end

end
