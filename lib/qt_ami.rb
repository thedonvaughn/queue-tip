# qt_ami.rb - Copyright 2008 Jayson Vaughn 
# Distributed under the terms of the GNU General Public License.
#
#    This file is part of Queue-Tip.
#
#    Queue-Tip is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    Queue-Tip is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with Queue-Tip.  If not, see <http://www.gnu.org/licenses/>.
#
require 'drb'

class QtAmi
  def initialize(args = {})
    @drb = DRbObject.new_with_uri 'druby://localhost:9050'
  end

  public

  def queue_status
    @drb.queue_status
  end

  def agent_logoff(args = {})
    @drb.send_action 'QueueRemove', :queue => args[:queue], :interface => args[:interface]
  end

  def agent_pause(interface)
    @drb.send_action 'QueuePause', :interface => interface, :paused => true
  end

  def agent_unpause(interface)
    @drb.send_action 'QueuePause', :interface => interface, :paused => false
  end
  
  def log_off_all_agents
    qstats = self.queue_status
    qstats.each do |key, value|
      qstats[key][:members].each do |agent, elements|
        self.agent_logoff(:queue => key, :interface => agent)
      end
    end
  end

  def reset_queue
    @drb.send_action 'Command', 'Command' => 'module reload app_queue'
  end
end
