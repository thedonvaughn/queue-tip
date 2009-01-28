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

  def test_queu_method_queue_calls
    queue = Queu.find(queus(:two))
    assert queue.kind_of?(Queu), "No queue could be found!"
    total_calls = queue.queue_calls(9, 8, 2008, 9, 8, 2008)
    assert total_calls == 2, "total_calls for this queue does NOT equal 2!"
  end

  def test_queu_method_connected_calls
    queue = Queu.find(queus(:two))
    assert queue.kind_of?(Queu), "No queue could be found!"
    connected_calls = queue.connected_calls(9, 8, 2008, 9, 8, 2008)
    assert connected_calls == 2, "connected_calls for this queue does NOT equal 2!"
  end

  def test_queu_method_total_abandons
    queue = Queu.find(queus(:two))
    assert queue.kind_of?(Queu), "No queue could be found!"
    total_abandons = queue.total_abandons(9, 8, 2008, 9, 8, 2008)
    assert total_abandons == 2, "total_abandons for this queue does NOT equal 2!"
  end

  def test_queu_method_short_abandons
    queue = Queu.find(queus(:two))
    assert queue.kind_of?(Queu), "No queue could be found!"
    short_abandons = queue.short_abandons(9, 8, 2008, 9, 8, 2008)
    assert short_abandons == 1, "short_abandons for this queue does NOT equal 1!"
  end

  def test_queu_method_reg_abandons
    queue = Queu.find(queus(:two))
    assert queue.kind_of?(Queu), "No queue could be found!"
    reg_abandons = queue.reg_abandons(9, 8, 2008, 9, 8, 2008)
    assert reg_abandons == 1, "reg_abandons for this queue does NOT equal 1!"
  end

  def test_queu_method_total_calls
    queue = Queu.find(queus(:two))
    assert queue.kind_of?(Queu), "No queue could be found!"
    total_calls = queue.total_calls(9, 8, 2008, 9, 8, 2008)
    assert total_calls == 1, "total_calls for this queue does NOT equal 1!"
  end

  def test_queu_method_service_level_percentage
    queue = Queu.find(queus(:two))
    assert queue.kind_of?(Queu), "No queue could be found!"
    srv_lvl_avg = queue.service_level_percentage(9, 8, 2008, 9, 8, 2008)
    assert srv_lvl_avg.to_f == 50.0, "service level percentage for this queue does NOT equal 50%!"
  end

  def test_queu_method_average_caller_wait_time
    queue = Queu.find(queus(:two))
    assert queue.kind_of?(Queu), "No queue could be found!"
    avg_caller_wait_time = queue.average_caller_wait_time(9, 8, 2008, 9, 8, 2008)
    assert avg_caller_wait_time.to_f == 66.00, "Average caller wait time for this queue does NOT equal 66.0!"
  end

  def test_queu_method_average_caller_reso_time
    queue = Queu.find(queus(:two))
    assert queue.kind_of?(Queu), "No queue could be found!"
    avg_caller_reso_time = queue.average_caller_reso_time(9, 8, 2008, 9, 8, 2008)
    assert avg_caller_reso_time.to_f == 483.50, "Average caller reso time for this queue does NOT equal 485.50!"
  end

  def test_queu_method_average_caller_abandon_time
    queue = Queu.find(queus(:two))
    assert queue.kind_of?(Queu), "No queue could be found!"
    avg_caller_abandon_time = queue.average_caller_abandon_time(9, 8, 2008, 9, 8, 2008)
    assert avg_caller_abandon_time.to_f == 75.00, "Average caller abandon time for this queue does NOT equal 75.0!"
  end

  def test_queu_method_abandon_percentage
    queue = Queu.find(queus(:two))
    assert queue.kind_of?(Queu), "No queue could be found!"
    abandon_percentage = queue.abandon_percentage(9, 8, 2008, 9, 8, 2008)
    assert abandon_percentage.to_f == 100.00, "Abandon percentage for this queue does NOT equal 100%!"
  end

end
