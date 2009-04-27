require 'test_helper'

class QueuTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end

  def test_should_have_a_queu
    queue = Queu.find(queus(:one))
    assert queue.kind_of?(Queu), "No queue could be found!"
  end
  
  def test_queu_should_have_actions
    queue = Queu.find(queus(:two))
    assert queue.kind_of?(Queu), "No queue could be found!"
    action = queue.actions.first
    assert action.kind_of?(Action), "No actions belong to this queue!" 
  end

end
