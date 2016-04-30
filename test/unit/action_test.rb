require 'test_helper'

class ActionTest < ActiveSupport::TestCase
  def test_should_have_an_action
    action = Action.find(actions(:one))
    assert action.kind_of?(Action), "No Action could be found!"
  end
  
  def action_should_belong_to_an_agent
    action = Action.find(actions(:one))
    agent = action.agent
    assert agent.kind_of?(Agent), "No agent associated with this action"
  end

  def action_should_belong_to_a_queue
    action = Action.find(actions(:one))
    queue = action.queu
    assert queue.kind_of?(Queu), "No queue associated with this action" 
  end

end
