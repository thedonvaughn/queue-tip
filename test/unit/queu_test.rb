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
    assert call_count == 6, "#{call_count} does not equal 6"
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

  def test_service_level_perc
    config = QueueTip.config
    queue = Queu.find(queus(:two))
    service_level_perc = queue.service_level_percentage(5, 8, 2009, 5, 8, 2009)
    assert service_level_perc.to_f == 50.0, "#{service_level_perc} does not equal 50"
  end

  def test_average_caller_wait_time
    queue = Queu.find(queus(:two))
    average_caller_wait = queue.average_caller_wait_time(5, 8, 2009, 5, 8, 2009)
    assert average_caller_wait.to_f == 57.0, "#{average_caller_wait} does not equal 57.0"
  end

  def test_average_caller_reso_time
    queue = Queu.find(queus(:two))
    average_caller_reso_time = queue.average_caller_reso_time(5, 8, 2009, 5, 8, 2009)
    assert average_caller_reso_time.to_f == 30.0, "#{average_caller_reso_time} does not equal 30.0"
  end

  def test_average_caller_abandon_time
    queue = Queu.find(queus(:two))
    average_caller_aban_time = queue.average_caller_abandon_time(5, 8, 2009, 5, 8, 2009)
    assert average_caller_aban_time.to_f == 124.50, "#{average_caller_aban_time} does not equal 124.50"
  end

  def test_abandon_percentage
    queue = Queu.find(queus(:two))
    aban_perc = queue.abandon_percentage(5, 8, 2009, 5, 8, 2009)
    assert aban_perc.to_f == 66.67, "#{aban_perc} does not equal 66.67"
  end

end
