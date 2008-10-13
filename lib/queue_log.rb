# queue_log.rb - Copyright 2008 Jayson Vaughn 
# Distributed under the terms of the GNU General Public License.
#
#    This file is part of Queuetastic.
#
#    Queuetastic is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    Queuetastic is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with Queuetastic.  If not, see <http://www.gnu.org/licenses/>.
#


class QueueLog

  def initialize(args = {})
    @config = Queuetastic.config
    @queue_log = @config['queuetastic']['queue_log'] || "/var/log/asterisk/queue_log"
    @new_records = 0
  end

  def process_log_file
    File.open(@queue_log, 'r').each_line do |line|
      self.add_aaction(line) if line =~ /ADDMEMBER|REMOVEMEMBER|PAUSE/ and line !~ /PAUSEALL|UNPAUSEALL/
      self.add_caction(line) if line =~ /CONNECT|COMPLETEAGENT|COMPLETECALLER/
      self.add_caction_no_agent(line) if line =~ /ABANDON|ENTERQUEUE/
    end
    return @new_records
  end

  def add_aaction(string)
    member = string.split('|')
    unless member[1] =~ /MANAGER|NONE/
      unless aaction = Aaction.find_by_uniqueid(member[1].to_s)
        queue = test_queue(member[2]) 
        agent = test_agent(member[3])
        @new_records += 1 if aaction = Aaction.create(:agent_id => agent.id, :channel => member[3], :timestamp => member[0].to_f, :queu_id => queue.id, :queue_name => member[2], :uniqueid => member[1].to_s, :action => member[4])
      end
    else
      aaction = Aaction.find(:all, :conditions => ['timestamp = ? and channel = ? and action = ?', member[0].to_f, member[3].to_s, member[4].to_s])
      if aaction.empty?
        queue = test_queue(member[2]) 
        agent = test_agent(member[3])
        @new_records += 1 if aaction = Aaction.create(:agent_id => agent.id, :channel => member[3], :timestamp => member[0].to_f, :queu_id => queue.id, :queue_name => member[2], :uniqueid => Time.now.to_f.to_s, :action => member[4])
      end
    end
    return aaction
  end

  def add_caction(string)
    caction = string.split('|')
    queue = test_queue(caction[2])
    agent = test_agent(caction[3])
    unless call = Call.find_by_uniqueid(caction[1].to_s)
      @new_records += 1 if call = Call.create(:agent_id => agent.id, :cid => caction[6].to_s.chomp, :queu_id => queue.id, :queue_name => caction[2], :timestamp => caction[0].to_f, :uniqueid => caction[1].to_s)
    end
    call.agent_id = agent.id
    call.save
    cactions = Caction.find(:all, :conditions => ['uniqueid = ? and action = ?', caction[1].to_s, caction[4].to_s])
    if cactions.empty?
      @new_records += 1 if new_caction = Caction.create(:timestamp => caction[0].to_f, :channel => caction[3], :agent_id => agent.id, :queu_id => queue.id, :queue_name => caction[2], :call_id => call.id, :uniqueid => caction[1].to_s, :action => caction[4], :field1 => caction[5].to_s.chomp, :field2 => caction[6].to_s.chomp, :field3 => caction[7].to_s.chomp)
    end
    return call
  end

  def add_caction_no_agent(string)
    caction = string.split('|')
    queue = test_queue(caction[2])
    unless call = Call.find_by_uniqueid(caction[1].to_s)
      @new_records += 1 if call = Call.create(:cid => caction[6].to_s.chomp, :queu_id => queue.id, :queue_name => caction[2], :timestamp => caction[0].to_f, :uniqueid => caction[1].to_s)
    end
    cactions = Caction.find(:all, :conditions => ['uniqueid = ? and action = ?', caction[1].to_s, caction[4].to_s])
    if cactions.empty?
      @new_records += 1 if new_caction = Caction.create(:timestamp => caction[0].to_f, :queu_id => queue.id, :queue_name => caction[2], :call_id => call.id, :uniqueid => caction[1].to_s, :action => caction[4].to_s, :field1 => caction[5].to_s.chomp, :field2 => caction[6].to_s.chomp, :field3 => caction[7].to_s.chomp)
    end
    return call
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
    # If agent channel is Local/XXXX@context format, extract the agent number
    channel = channel.split('@')[0].split('/')[-1] if channel =~ /Local/
    agent = Agent.find_by_channel(channel)
    if agent.nil?
      Agent.create(:channel => channel)
      agent = Agent.find_by_channel(channel)
    end
    return agent
  end

end
