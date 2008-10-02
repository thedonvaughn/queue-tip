require 'test_helper'

class CactionTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end

  def test_have_a_caction
    caction = Caction.find(cactions(:one))
    assert caction.kind_of?(Caction), "No Caction could be found!"
  end

  def test_caction_belongs_to_a_call
    caction = Caction.find(cactions(:two))
    assert caction.kind_of?(Caction), "No Caction could be found!"
    call = caction.call
    assert call.kind_of?(Call), "Caction doesn't belong to a call, something is wrong!"
  end

  def test_caction_belongs_to_a_queue
    caction = Caction.find(cactions(:two))
    assert caction.kind_of?(Caction), "No Caction could be found!"
    queue = caction.queu
    assert queue.kind_of?(Queu), "Caction doesn't belong to a call, something is wrong!"
  end

  def test_caction_belongs_to_an_agent
    caction = Caction.find(cactions(:two))
    assert caction.kind_of?(Caction), "No Caction could be found!"
    agent = caction.agent
    assert agent.kind_of?(Agent), "This caction doesn't belong to an agent!"
  end

end
