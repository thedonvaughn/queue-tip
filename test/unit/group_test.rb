require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  def test_a_group_exists
    group = Group.find(groups(:one))
    assert group.kind_of?(Group), "No group can be found!"
  end

  def test_a_group_has_agents
    group = Group.find(groups(:one))
    assert group.kind_of?(Group), "No group can be found!"
    agent = group.agents.first
    assert agent.kind_of?(Agent), "This group does not have any agents!"
  end

end
