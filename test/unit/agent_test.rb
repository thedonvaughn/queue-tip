require 'test_helper'

class AgentTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end

  def test_have_an_agent
    agent = Agent.find(agents(:one))
    assert agent.kind_of?(Agent), "No agent could be found!"
  end

  def test_agent_has_a_call
    agent = Agent.find(agents(:one))
    assert agent.kind_of?(Agent), "No agent could be found!"
    call = agent.calls.first
    assert call, "No calls associated with agent!"
  end

  def test_agent_belongs_to_a_group
    agent = Agent.find(agents(:two))
    assert agent.kind_of?(Agent), "No agent could be found!"
    group = agent.group
    assert group.kind_of?(Group), "Agent doesn't belong to a group"
  end

  def test_agent_has_aactions
    agent = Agent.find(agents(:two))
    assert agent.kind_of?(Agent), "No agent could be found!"
    aaction = agent.aactions.first
    assert aaction.kind_of?(Aaction), "No aactions belong to this agent!"
  end

  def test_agent_has_cactions
    agent = Agent.find(agents(:two))
    assert agent.kind_of?(Agent), "No agent could be found!"
    caction = agent.cactions.first
    assert caction.kind_of?(Caction), "No cactions belong to this agent!"
  end

  def test_agent_login_time
    agent = Agent.find(agents(:two))
    assert agent.kind_of?(Agent), "No agent could be found!"
    total_time = agent.login_time(9, 8, 2008, 9, 8, 2008) # Fixture timestamp is set for 9/8/2008
    assert total_time == 430.5, "login_time for Agent does NOT equal 430.5"
  end

  def test_agent_pause_time
    agent = Agent.find(agents(:two))
    assert agent.kind_of?(Agent), "No agent could be found!"
    pause_time = agent.pause_time(9, 8, 2008, 9, 8, 2008) # Fixture timestamp is set for 9/8/2008
    assert pause_time == 16.83, "pause_time for Agent does NOT equal 16.83"
  end

  def test_agent_talk_time
    agent = Agent.find(agents(:two))
    assert agent.kind_of?(Agent), "No agent could be found!"
    talk_time = agent.talk_time(9, 8, 2008, 9, 8, 2008) # Fixture timestamp is set for 9/8/2008
    assert talk_time == 16.12, "talk_time for Agent does NOT equal 16.12"
  end

  def test_agent_wait_time
    agent = Agent.find(agents(:two))
    assert agent.kind_of?(Agent), "No agent could be found!"
    wait_time = agent.wait_time(9, 8, 2008, 9, 8, 2008) # Fixture timestamp is set for 9/8/2008
    assert wait_time.to_f == 414.38, "wait_time for Agent does NOT equal 414.38"
  end

  def test_agent_count_calls
    agent = Agent.find(agents(:two))
    assert agent.kind_of?(Agent), "No agent could be found!"
    total_calls = agent.count_calls(9, 8, 2008, 9, 8, 2008) # Fixture timestamp is set for 9/8/2008
    assert total_calls == 2, "total_calls for Agent does NOT equal 2"
  end

  def test_agent_avg_resolution_time
    agent = Agent.find(agents(:two))
    assert agent.kind_of?(Agent), "No agent could be found!"
    total_time = agent.average_reso_time(9, 8, 2008, 9, 8, 2008) # Fixture timestamp is set for 9/8/2008
    assert total_time.to_f == 8.06, "total_time for resolution for Agent does NOT equal 8.06"
  end

end
