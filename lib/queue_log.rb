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
      self.addmember(line) if line =~ /ADDMEMBER/
      self.remove_member(line) if line =~ /REMOVEMEMBER/
      self.enter_queue(line) if line =~ /ENTERQUEUE/
      self.connect(line) if line =~ /CONNECT/
      self.abandon(line) if line =~ /ABANDON/
      self.complete_agent(line) if line =~ /COMPLETEAGENT/
      self.complete_caller(line) if line =~ /COMPLETECALLER/
      self.pause(line) if line =~ /PAUSE/ and line !~ /PAUSEALL|UNPAUSE/
      self.unpause(line) if line =~ /UNPAUSE/ and line !~ /UNPAUSEALL/
    end
    return @new_records
  end

  ###############################################
  # REALLY REALLY NEED TO THIS DRY THIS MESS UP #
  ###############################################

  def addmember(string)
    member = string.split('|')
    unless member[1] =~ /MANAGER/
      unless aaction = Aaction.find_by_uniqueid(member[1])
       queue = test_queue(member[2]) 
       agent = test_agent(member[3])
       @new_records += 1 if aaction = Aaction.create(:agent_id => agent.id, :channel => member[3], :timestamp => member[0].to_f, :queu_id => queue.id, :queue_name => member[2], :uniqueid => member[1], :action => member[4])
      end
    else
       queue = test_queue(member[2]) 
       agent = test_agent(member[3])
       @new_records += 1 if aaction = Aaction.create(:agent_id => agent.id, :channel => member[3], :timestamp => member[0].to_f, :queu_id => queue.id, :queue_name => member[2], :uniqueid => Time.now.to_f, :action => member[4])
    end
    return aaction
  end

  def remove_member(string)
    member = string.split('|')
    unless member[1] =~ /MANAGER/
      unless aaction = Aaction.find_by_uniqueid(member[1])
       queue = test_queue(member[2]) 
       agent = test_agent(member[3])
       @new_records += 1 if aaction = Aaction.create(:agent_id => agent.id, :channel => member[3], :timestamp => member[0].to_f, :queu_id => queue.id, :queue_name => member[2], :uniqueid => member[1], :action => member[4])
      end
    else
      unless aaction = Aaction.find(:all, :conditions => ['timestamp = ? and channel = ? and action = ?', member[0].to_f, member[3].to_s, "REMOVEMEMBER"])
        queue = test_queue(member[2]) 
        agent = test_agent(member[3])
        @new_records += 1 if aaction = Aaction.create(:agent_id => agent.id, :channel => member[3], :timestamp => member[0].to_f, :queu_id => queue.id, :queue_name => member[2], :uniqueid => Time.now.to_f, :action => member[4])
      end
    end
    return aaction
  end

  def pause(string)
    member = string.split('|')
    aaction = Aaction.find(:all, :conditions => ['timestamp = ? and channel = ? and action = ?', member[0].to_f, member[3].to_s, "PAUSE"])
    if aaction.empty?
      queue = test_queue(member[2]) 
      agent = test_agent(member[3])
      @new_records += 1 if aaction = Aaction.create(:agent_id => agent.id, :channel => member[3], :timestamp => member[0].to_f, :queu_id => queue.id, :queue_name => member[2], :uniqueid => Time.now.to_f, :action => member[4])
    end
    return aaction
  end

  def unpause(string)
    member = string.split('|')
    aaction = Aaction.find(:all, :conditions => ['timestamp = ? and channel = ? and action = ?', member[0].to_f, member[3].to_s, "UNPAUSE"])
    if aaction.empty?
      queue = test_queue(member[2]) 
      agent = test_agent(member[3])
      @new_records += 1 if aaction = Aaction.create(:agent_id => agent.id, :channel => member[3], :timestamp => member[0].to_f, :queu_id => queue.id, :queue_name => member[2], :uniqueid => Time.now.to_f, :action => member[4])
    end
    return aaction
  end

  def enter_queue(string)
    caction = string.split('|')
    queue = test_queue(caction[2])
    unless call = Call.find_by_uniqueid(caction[1].to_f)
      @new_records += 1 if call = Call.create(:cid => caction[6].to_s.chomp, :queu_id => queue.id, :queue_name => caction[2], :timestamp => caction[0].to_f, :uniqueid => caction[1].to_f)
    end
    cactions = Caction.find(:all, :conditions => ['uniqueid = ? and action = ?', caction[1], "ENTERQUEUE"])
    if cactions.empty?
      @new_records += 1 if new_caction = Caction.create(:timestamp => caction[0].to_f, :queu_id => queue.id, :queue_name => caction[2], :call_id => call.id, :uniqueid => caction[1].to_f, :action => caction[4], :field2 => caction[6].to_s.chomp)
    end
    return call
  end

  def connect(string)
    caction = string.split('|')
    agent = test_agent(caction[3])
    queue = test_queue(caction[2])
    unless call = Call.find_by_uniqueid(caction[1].to_f)
      @new_records += 1 if call = Call.create(:agent_id => agent.id, :cid => caction[6].to_s.chomp, :queu_id => queue.id, :queue_name => caction[2], :timestamp => caction[0].to_f, :uniqueid => caction[1].to_f)
    end
    call.agent_id = agent.id
    call.save
    cactions = Caction.find(:all, :conditions => ['uniqueid = ? and action = ?', caction[1], "CONNECT"])
    if cactions.empty?
      @new_records += 1 if new_caction = Caction.create(:timestamp => caction[0].to_f, :channel => caction[3], :agent_id => agent.id, :queu_id => queue.id, :queue_name => caction[2], :call_id => call.id, :uniqueid => caction[1].to_f, :action => caction[4], :field1 => caction[5].to_s.chomp, :field2 => caction[6].to_s.chomp)
    end
    return call
  end

  def ringnoanswer(string)
    caction = string.split('|')
    agent = test_agent(caction[3])
    queue = test_queue(caction[2])
    unless call = Call.find_by_uniqueid(caction[1].to_f)
      @new_records += 1 if call = Call.create(:cid => caction[6].to_s.chomp, :queu_id => queue.id, :queue_name => caction[2], :timestamp => caction[0].to_f, :uniqueid => caction[1].to_f)
    end
    cactions = Caction.find(:all, :conditions => ['uniqueid = ? and action = ? and timestamp = ? and channel = ?', caction[1], "RINGNOANSWER", caction[0].to_f, caction[3].to_s])
    if cactions.empty?
      @new_records += 1 if new_caction = Caction.create(:timestamp => caction[0].to_f, :channel => caction[3], :agent_id => agent.id, :queu_id => queue.id, :queue_name => caction[2], :call_id => call.id, :uniqueid => caction[1].to_f, :action => caction[4], :field1 => caction[5].to_s.chomp)
    end
    return call
  end

  def abandon(string)
    caction = string.split('|')
    queue = test_queue(caction[2])
    unless call = Call.find_by_uniqueid(caction[1].to_f)
      @new_records += 1 if call = Call.create(:cid => caction[6].to_s.chomp, :queu_id => queue.id, :queue_name => caction[2], :timestamp => caction[0].to_f, :uniqueid => caction[1].to_f)
    end
    cactions = Caction.find(:all, :conditions => ['uniqueid = ? and action = ?', caction[1], "ABANDON"])
    if cactions.empty?
      @new_records += 1 if new_caction = Caction.create(:timestamp => caction[0].to_f, :queu_id => queue.id, :queue_name => caction[2], :call_id => call.id, :uniqueid => caction[1].to_f, :action => caction[4], :field1 => caction[5].to_s.chomp, :field2 => caction[6].to_s.chomp, :field3 => caction[7].to_s.chomp)
    end
    return call
  end

  def complete_agent(string)
    caction = string.split('|')
    agent = test_agent(caction[3])
    queue = test_queue(caction[2])
    unless call = Call.find_by_uniqueid(caction[1].to_f)
      @new_records += 1 if call = Call.create(:agent_id => agent.id, :cid => caction[6].to_s.chomp, :queu_id => queue.id, :queue_name => caction[2], :timestamp => caction[0].to_f, :uniqueid => caction[1].to_f)
    end
    call.agent_id = agent.id
    call.save
    cactions = Caction.find(:all, :conditions => ['uniqueid = ? and action = ?', caction[1], "COMPLETEAGENT"])
    if cactions.empty?
      @new_records += 1 if new_caction = Caction.create(:timestamp => caction[0].to_f, :channel => caction[3], :agent_id => agent.id, :queu_id => queue.id, :queue_name => caction[2], :call_id => call.id, :uniqueid => caction[1].to_f, :action => caction[4], :field1 => caction[5].to_s.chomp, :field2 => caction[6].to_s.chomp, :field3 => caction[7].to_s.chomp)
    end
    return call
  end

  def complete_caller(string)
    caction = string.split('|')
    agent = test_agent(caction[3])
    queue = test_queue(caction[2])
    unless call = Call.find_by_uniqueid(caction[1].to_f)
      @new_records += 1 if call = Call.create(:agent_id => agent.id, :cid => caction[6].to_s.chomp, :queu_id => queue.id, :queue_name => caction[2], :timestamp => caction[0].to_f, :uniqueid => caction[1].to_f)
    end
    call.agent_id = agent.id
    call.save
    cactions = Caction.find(:all, :conditions => ['uniqueid = ? and action = ?', caction[1], "COMPLETECALLER"])
    if cactions.empty?
      @new_records += 1 if new_caction = Caction.create(:timestamp => caction[0].to_f, :channel => caction[3], :agent_id => agent.id, :queu_id => queue.id, :queue_name => caction[2], :call_id => call.id, :uniqueid => caction[1].to_f, :action => caction[4], :field1 => caction[5].to_s.chomp, :field2 => caction[6].to_s.chomp, :field3 => caction[7].to_s.chomp)
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
    agent = Agent.find_by_channel(channel)
    if agent.nil?
      Agent.create(:channel => channel)
      agent = Agent.find_by_channel(channel)
    end
    return agent
  end

end
