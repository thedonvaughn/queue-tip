require 'test_helper'

class AactionTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  #
  def test_truth
    assert true
  end

  def test_should_have_an_aaction
    aaction = Aaction.find(aactions(:one))
    assert aaction
    assert aaction.kind_of?(Aaction)
  end

  def test_aaction_belongs_to_an_agent
    aaction = Aaction.find(aactions(:one))
    assert aaction
    agent = aaction.agent
    assert agent.kind_of?(Agent), "Hey, no agent is associated with an Aaction.!  #{aaction.agent}"
  end

  def test_aaction_belongs_to_an_agent_and_a_queue
    aaction = Aaction.find(aactions(:two))
    assert aaction
    assert aaction.agent.kind_of?(Agent), "Hey, no agent is associated with this Aaction!  #{aaction.agent}"
    assert aaction.queu.kind_of?(Queu), "Hey, no queue is associated with this Aaction! #{aaction.queu}"
  end

end
