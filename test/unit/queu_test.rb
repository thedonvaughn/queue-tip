require 'test_helper'

class QueuTest < ActiveSupport::TestCase
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

  def test_queu_call_count
    queue = Queu.find(queus(:two))
    call_count = queue.queue_calls(5, 8, 2009, 5, 8, 2009)
    assert call_count == 2, "#{call_count} does not equal 2"
  end

  def test_queue_connected_call_count
    queue = Queu.find(queus(:two))
    connected_calls = queue.connected_calls(5, 8, 2009, 5, 8, 2009)
    assert connected_calls == 2, "#{connected_calls} does note equal 2"
  end

  def test_total_abandoned_count
    queue = Queu.find(queus(:two))
    total_abandons = queue.total_abandons(5, 8, 2009, 5, 8, 2009)
    assert total_abandons == 4, "#{total_abandons} does not equal 4"
  end

  def test_short_abandoned_count
    queue = Queu.find(queus(:two))
    short_abandons = queue.short_abandons(5, 8, 2009, 5, 8, 2009)
    assert short_abandons == 2, "#{short_abandons} does not equal 2"
  end

  def test_reg_abandoned_count
    queue = Queu.find(queus(:two))
    reg_abandons = queue.reg_abandons(5, 8, 2009, 5, 8, 2009)
    assert reg_abandons == 2, "#{reg_abandons} does not equal 2"
  end

end
