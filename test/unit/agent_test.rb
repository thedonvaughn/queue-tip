require 'test_helper'

class AgentTest < ActiveSupport::TestCase

  def test_have_an_agent
    agent = Agent.find(agents(:one))
    assert agent.kind_of?(Agent), "No agent could be found!"
  end

  def test_agent_belongs_to_a_group
    agent = Agent.find(agents(:two))
    assert agent.kind_of?(Agent), "No agent could be found!"
    group = agent.group
    assert group.kind_of?(Group), "Agent doesn't belong to a group"
  end

  def test_agent_has_actions
    agent = Agent.find(agents(:two))
    assert agent.kind_of?(Agent), "No agent could be found!"
    action = agent.actions.first
    assert action.kind_of?(Action), "No actions belong to this agent!"
  end

  def test_agent_login_time
    agent = Agent.find(agents(:two))
    assert agent.kind_of?(Agent), "No agent could be found!"
    total_time = agent.login_time(5, 8, 2009, 5, 8, 2009) # Fixture timestamp is set for 5/8/2009
    assert total_time == 480, "login_time for Agent does NOT equal 480 #{total_time} (minutes)"
  end

  def test_agent_pause_time
    agent = Agent.find(agents(:two))
    assert agent.kind_of?(Agent), "No agent could be found!"
    pause_time = agent.pause_time(5, 8, 2009, 5, 8, 2009) # Fixture timestamp is set for 5/8/2009
    assert pause_time == 60.0, "#{pause_time} pause_time for Agent does NOT equal 60.0 (minutes)"
  end

  def test_agent_talk_time
    agent = Agent.find(agents(:two))
    assert agent.kind_of?(Agent), "No agent could be found!"
    talk_time = agent.talk_time(5, 8, 2009, 5, 8, 2009) # Fixture timestamp is set for 5/8/2009
    assert talk_time == 1.0, "#{talk_time} talk_time for Agent does NOT equal 1.0 (minutes)"
  end

  def test_agent_wait_time
   agent = Agent.find(agents(:two))
   assert agent.kind_of?(Agent), "No agent could be found!"
   wait_time = agent.wait_time(5, 8, 2009, 5, 8, 2009) # Fixture timestamp is set for 5/9/2009
   assert wait_time.to_f == 419.0, "#{wait_time.to_f} wait_time for Agent does NOT equal 360.00 (minutes)"
 end

 def test_agent_count_calls
   agent = Agent.find(agents(:two))
   assert agent.kind_of?(Agent), "No agent could be found!"
   total_calls = agent.count_calls(5, 8, 2009, 5, 8, 2009) # Fixture timestamp is set for 9/8/2008
   assert total_calls == 2, "#{total_calls} total_calls for Agent does NOT equal 2"
 end

 def test_agent_avg_resolution_time
   agent = Agent.find(agents(:two))
   assert agent.kind_of?(Agent), "No agent could be found!"
   total_time = agent.average_reso_time(5, 8, 2009, 5, 8, 2009) # Fixture timestamp is set for 9/8/2008
   assert total_time.to_f == 0.5, "#{total_time} total_time for resolution for Agent does NOT equal 0.5 (minutes, i.e 30 secs)"
 end

end
