# queu.rb - Copyright 2008 Jayson Vaughn 
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

class Queu < ActiveRecord::Base
  has_many :actions

  def queue_calls(bmonth, bday, byear, emonth, eday, eyear)
    self.actions.find(:all, :conditions => ['timestamp >= ?  and timestamp <= ? and action = ?', Time.parse("#{bmonth}/#{bday} #{byear}").to_i, Time.parse("#{emonth}/#{eday} #{eyear} 23:59:59").to_i, "ENTERQUEUE"]).size
  end

  def connected_calls(bmonth, bday, byear, emonth, eday, eyear)
    self.actions.find(:all, :conditions => ['timestamp >= ?  and timestamp <= ? and action = ?', Time.parse("#{bmonth}/#{bday} #{byear}").to_i, Time.parse("#{emonth}/#{eday} #{eyear} 23:59:59").to_i, "CONNECT"]).size
  end

  def total_abandons(bmonth, bday, byear, emonth, eday, eyear)
    self.actions.find(:all, :conditions => ['timestamp >= ?  and timestamp <= ? and action = ?', Time.parse("#{bmonth}/#{bday} #{byear}").to_i, Time.parse("#{emonth}/#{eday} #{eyear} 23:59:59").to_i, "ABANDON"]).size
  end
  
  def short_abandons(bmonth, bday, byear, emonth, eday, eyear)
    abandons = self.actions.find(:all, :conditions => ['timestamp >= ?  and timestamp <= ? and action = ?', Time.parse("#{bmonth}/#{bday} #{byear}").to_i, Time.parse("#{emonth}/#{eday} #{eyear} 23:59:59").to_i, "ABANDON"])
    abandons.select { |a| a if a.data3.to_f <= 60.00 }.size
  end

  def reg_abandons(bmonth, bday, byear, emonth, eday, eyear)
    abandons = self.actions.find(:all, :conditions => ['timestamp >= ?  and timestamp <= ? and action = ?', Time.parse("#{bmonth}/#{bday} #{byear}").to_i, Time.parse("#{emonth}/#{eday} #{eyear} 23:59:59").to_i, "ABANDON"])
    abandons.select { |a| a if a.data3.to_f >= 60.00 }.size
  end

  def service_level_percentage(bmonth, bday, byear, emonth, eday, eyear)
    config = QueueTip.config
    calls = self.actions.find(:all, :conditions => ['(timestamp >= ? and timestamp <= ?) and (action = ? or action = ?)', Time.parse("#{bmonth}/#{bday} #{byear}").to_i, Time.parse("#{emonth}/#{eday} #{eyear} 23:59:59").to_i, "COMPLETECALLER", "COMPLETEAGENT"])
    service_calls = calls.select { |call| call if call.data1.to_f <= config['queuetip']['service_level'].to_f }
    if calls.size >= 1
      return "%0.2f" % ((service_calls.size.to_f / calls.size.to_f) * 100)  
    else
      return 0
    end
  end

  def average_caller_wait_time(bmonth, bday, byear, emonth, eday, eyear)
    total_time = 0.0
    complete_calls = self.actions.find(:all, :conditions => ['(timestamp >= ? and timestamp <= ?) and (action = ? or action = ?)', Time.parse("#{bmonth}/#{bday} #{byear}").to_i, Time.parse("#{emonth}/#{eday} #{eyear} 23:59:59").to_i, "COMPLETECALLER", "COMPLETEAGENT"])
    complete_calls.each { |call| total_time += call.data1.to_f } 
    if complete_calls.size >= 1
      return "%0.2f" % (total_time / complete_calls.size.to_f)
    else
      return 0
    end
  end

  def average_caller_reso_time(bmonth, bday, byear, emonth, eday, eyear)
    total_time = 0.0
    complete_calls = self.actions.find(:all, :conditions => ['(timestamp >= ? and timestamp <= ?) and (action = ? or action = ?)', Time.parse("#{bmonth}/#{bday} #{byear}").to_i, Time.parse("#{emonth}/#{eday} #{eyear} 23:59:59").to_i, "COMPLETECALLER", "COMPLETEAGENT"])
    complete_calls.each { |call| total_time += call.data2.to_f } 
    if complete_calls.size >= 1
      return "%0.2f" % (total_time / complete_calls.size.to_f)
    else
      return 0
    end
  end

  def average_caller_abandon_time(bmonth, bday, byear, emonth, eday, eyear)
    total_time = 0.0
    abandons = self.actions.find(:all, :conditions => ['timestamp >= ? and timestamp <= ? and action = ?', Time.parse("#{bmonth}/#{bday} #{byear}").to_i, Time.parse("#{emonth}/#{eday} #{eyear} 23:59:59").to_i, "ABANDON"])
    abandons.each { |call| total_time += call.data3.to_f } 
    if abandons.size >= 1
      return "%0.2f" % (total_time / abandons.size.to_f)
    else
      return 0
    end
  end

  def abandon_percentage(bmonth, bday, byear, emonth, eday, eyear)
    total = queue_calls(bmonth, bday, byear, emonth, eday, eyear)
    abandons = total_abandons(bmonth, bday, byear, emonth, eday, eyear)
    if total > 0
      return "%0.2f" % ((abandons.to_f / total.to_f) * 100)
    else
      return 0
    end
  end

  def export_queue_report(bmonth, bday, byear, emonth, eday, eyear)
     [self.queue_name, self.queue_calls(bmonth, bday, byear, emonth, eday, eyear), self.connected_calls(bmonth, bday, byear, emonth, eday, eyear), self.service_level_percentage(bmonth, bday, byear, emonth, eday, eyear), self.average_caller_wait_time(bmonth, bday, byear, emonth, eday, eyear), self.average_caller_reso_time(bmonth, bday, byear, emonth, eday, eyear), self.total_abandons(bmonth, bday, byear, emonth, eday, eyear), self.short_abandons(bmonth, bday, byear, emonth, eday, eyear), self.reg_abandons(bmonth, bday, byear, emonth, eday, eyear), self.abandon_percentage(bmonth, bday, byear, emonth, eday, eyear), self.average_caller_abandon_time(bmonth, bday, byear, emonth, eday, eyear)]
  end

  def self.export_queue_header
    ["Queue","Total Calls","Conn. Calls", "Service Lvl.", "Avg. Wait(sec)", "Avg. Reso(sec)", "Total Abandons", "Short Abandons", "Reg Abandons", "Abandon Percentage", "Avg. Aband. Time"]
  end

  def self.log_off_all_agents
    ami = QtAmi.new
    ami.log_off_all_agents
  end

end
