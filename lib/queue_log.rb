# queue_log.rb - Copyright 2008 Jayson Vaughn 
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

require 'zlib'

def each_line(log)
  f = File.open(log)
  if log.end_with?('.gz')
    zf = Zlib::GzipReader.new(f)
  else
    zf = f
  end
  zf.each_line {|line| yield line}
  zf.close
end

class QueueLog

  def initialize(args = {})
    @config = QueueTip.config
    @queue_log = @config['queuetip']['queue_log'] || "/var/log/asterisk/queue_log"
    @new_records = 0
  end

  def process_log_file
    process_file(@queue_log)
    logs = Dir.glob(@queue_log + '*').sort_by{|filename| File.mtime(filename)}
    process_file(logs[-2]) if logs[-2]
  end

  def add_action(string)
    member = string.split('|')
    if member[1] =~ /MANAGER|NONE/
      actions = Action.find(:all, :conditions => ['timestamp = ? and channel = ? and action = ?', member[0].to_i, member[3].to_s, member[4].to_s])
      if actions.empty?
        queue = test_queue(member[2]) 
        agent = test_agent(member[3])
        @new_records += 1 if action = Action.create(:agent_id => agent.id, :channel => member[3], :timestamp => member[0].to_i, :queu_id => queue.id, :queue_name => member[2], :uniqueid => Time.now.to_f.to_s, :action => member[4], :data1 => member[5].to_s.chomp, :data2 => member[6].to_s.chomp, :data3 => member[7].to_s.chomp)
      else
        action = actions.first
      end
    else
      actions = Action.find(:all, :conditions => ['timestamp = ? and channel = ? and action = ?', member[0].to_i, member[3].to_s, member[4].to_s])
      if actions.empty?
        queue = test_queue(member[2]) 
        agent = test_agent(member[3])
        @new_records += 1 if action = Action.create(:agent_id => agent.id, :channel => member[3], :timestamp => member[0].to_i, :queu_id => queue.id, :queue_name => member[2], :uniqueid => member[1].to_s, :action => member[4], :data1 => member[5].to_s.chomp, :data2 => member[6].to_s.chomp, :data3 => member[7].to_s.chomp)
      else
        action = actions.first
      end
    end
    return action
  end

  def add_action_no_agent(string)
    member = string.split('|')
    queue = test_queue(member[2])
    actions = Action.find(:all, :conditions => ['uniqueid = ? and action = ?', member[1].to_s, member[4].to_s])
    if actions.empty?
      @new_records += 1 if action = Action.create(:timestamp => member[0].to_i, :queu_id => queue.id, :queue_name => member[2], :uniqueid => member[1].to_s, :action => member[4].to_s, :data1 => member[5].to_s.chomp, :data2 => member[6].to_s.chomp, :data3 => member[7].to_s.chomp)
    end
    return action
  end

  private

   def test_queue(qname)
    queue = Queu.find_by_queue_name(qname)
    if queue.nil?
      Queu.create(:queue_name => qname)
      queue = Queu.find_by_queue_name(qname)
    end
    return queue
  end

  def test_agent(channel)
    # If agent channel is SIP/XXX-xxxxx, split off of -
    channel = channel.split('-')[0]
    # If agent channel is Local/XXXX@context format, extract the agent number
    exten = channel.split('/')[-1] if channel =~ /SIP|IAX|/
    exten = channel.split('@')[0].split('/')[-1] if channel =~ /Local/
    agent = Agent.find_by_channel(channel)
    if agent.nil?
      Agent.create(:channel => channel, :exten => exten)
      agent = Agent.find_by_channel(channel)
    end
    return agent
  end

  def process_file(log)
    Action.transaction do # use one transaction to save commits/sync
      each_line(log) do |line|
        self.add_action(line) if line =~ /ADDMEMBER|REMOVEMEMBER|PAUSE|CONNECT|COMPLETEAGENT|COMPLETECALLER/ and line !~ /PAUSEALL|UNPAUSEALL/
        self.add_action_no_agent(line) if line =~ /ABANDON|ENTERQUEUE/
      end
    end
    return @new_records
  end
  
end
