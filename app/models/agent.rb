# agent.rb - Copyright 2008 Jayson Vaughn 
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

class Agent < ActiveRecord::Base
  belongs_to :group
  has_many :actions

  def count_calls(bmonth, bday, byear, emonth, eday, eyear)
    self.actions.find(:all, :conditions => ['timestamp >= ? and timestamp <= ? and action = ?', Time.parse("#{bmonth}/#{bday} #{byear}").to_i, Time.parse("#{emonth}/#{eday} #{eyear} 23:59:59").to_i, "CONNECT"]).size
  end

  def talk_time(bmonth, bday, byear, emonth, eday, eyear)
    complete_calls = self.actions.find(:all, :conditions => ['(timestamp >= ? and timestamp <= ?) and (action = ? or action = ?)', Time.parse("#{bmonth}/#{bday} #{byear}").to_i, Time.parse("#{emonth}/#{eday} #{eyear} 22:59:59").to_i, "COMPLETECALLER", "COMPLETEAGENT"])
    talk_time = 0
    complete_calls.each { |call| talk_time += call.data2.to_i }
    ("%0.2f" % (talk_time/60.0)).to_f
  end

  ######################################################
  # Not using wait_time method until login_time is used#
  ######################################################
  
  def wait_time(bmonth, bday, byear, emonth, eday, eyear) 
    "%0.2f" % (login_time(bmonth, bday, byear, emonth, eday, eyear).to_f - talk_time(bmonth, bday, byear, emonth, eday, eyear).to_f).to_f
  end

  def average_reso_time(bmonth, bday, byear, emonth, eday, eyear)
    total_time = 0.0
    complete_calls = self.actions.find(:all, :conditions => ['(timestamp >= ? and timestamp <= ?) and (action = ? or action = ?)', Time.parse("#{bmonth}/#{bday} #{byear}").to_i, Time.parse("#{emonth}/#{eday} #{eyear} 23:59:59").to_i, "COMPLETECALLER", "COMPLETEAGENT"])
    complete_calls.each { |call| total_time += call.data2.to_f }
    if complete_calls.size >= 1
      return "%0.2f" % ((total_time / complete_calls.size.to_f) / 60.0)
    else
      return 0
    end
  end

  def pause_time(bmonth, bday, byear, emonth, eday, eyear)
    total = 0.0
    bdate = Date.new(y=byear.to_i, m=bmonth.to_i, d=bday.to_i)
    edate = Date.new(y=eyear.to_i, m=emonth.to_i, d=eday.to_i)
    bdate.upto(edate) { |date|
      d = date.to_s.split('-')
      total += pause_time_per_day(d[1], d[2], d[0]).to_f
    }
    total
  end
  
  def login_time(bmonth, bday, byear, emonth, eday, eyear)
    total = 0.0
    bdate = Date.new(y=byear.to_i, m=bmonth.to_i, d=bday.to_i)
    edate = Date.new(y=eyear.to_i, m=emonth.to_i, d=eday.to_i)
    bdate.upto(edate) { |date| 
      d = date.to_s.split('-')
      total += login_time_per_day(d[1], d[2], d[0]).to_f
    }
    total
  end
  
  def pause_time_per_day(month, day, year) # Pretty ugly, need to re-write this
    pause_time = 0.0
    total_time = 0.0
    tmp_time = 0.0
    paused = false
    actions = self.actions.find(:all, :conditions => ['(timestamp >= ? and timestamp <= ?) and (action = ? or action = ?)', Time.parse("#{month}/#{day} #{year}").to_i, Time.parse("#{month}/#{day} #{year} 23:59:59").to_i, "PAUSE", "UNPAUSE"])
    actions = actions.sort_by { |action| action.timestamp }
    unless actions.empty?
      if actions.size > 1
        if actions.first.action.to_s == "PAUSE"
           actions.each do |action|
            if action.action.to_s == "PAUSE"
               paused = true
               pause_time = action.timestamp
            elsif action.action.to_s =~ /UNPAUSE/
              unless paused == false
               tmp_time = action.timestamp - pause_time
               total_time += (tmp_time/60.0)
               paused = false
              end
            end
          end
        end
      end
    end
    return "%0.2f" % (total_time).to_f
  end

  def export_agent_report(bmonth, bday, byear, emonth, eday, eyear)
    [self.channel, self.exten, self.first, self.last, self.count_calls(bmonth, bday, byear, emonth, eday, eyear), self.login_time(bmonth, bday, byear, emonth, eday, eyear), self.wait_time(bmonth, bday, byear, emonth, eday, eyear), self.talk_time(bmonth, bday, byear, emonth, eday, eyear), self.pause_time(bmonth, bday, byear, emonth, eday, eyear), self.average_reso_time(bmonth, bday, byear, emonth, eday, eyear)]
  end

  def self.export_agent_header
    ["Channel","Exten","First Name", "Last Name", "Total Calls", "Login Time", "Wait Time", "Talk Time", "Pause Time", "Avg. Reso."]
  end

  ####################################################################################################################
  # login_time_per_day method is very ugly.  Still need to re-write this.  Not actually using this in production yet.#
  ####################################################################################################################

  def login_time_per_day(month, day, year) 
    login_time = 0.0
    tmp_time = 0.0
    total_time = 0.0
    logged_in = false
    actions = Action.find(:all, :conditions => ['agent_id =? and timestamp >= ? and timestamp <= ?', self.id, Time.parse("#{month}/#{day} #{year}").to_i, Time.parse("#{month}/#{day} #{year} 23:59:59").to_i]).sort_by { |action| action.timestamp }
    unless actions.empty?
      if actions.size > 1
       if actions.first.action.to_s =~ /REMOVEMEMBER/ # If the first action is "REMOVEMEMBER" (i.e. no "ADDMEMBER" first.) we assume login at beginning of queue shift defined in LWTN's settings.
          login_time = Time.parse(Time.at(actions.first.timestamp).strftime("%m/%d %Y")).to_f 
          logged_in = true
          actions.each do |action|
           if action.action.to_s =~ /ADDMEMBER/
             unless logged_in == true
                logged_in = true
                login_time = action.timestamp
            end
           elsif action.action.to_s =~ /REMOVEMEMBER/
             unless logged_in == false
                tmp_time = action.timestamp - login_time
                total_time += (tmp_time/60.0)
               logged_in = false
              end
          end
        end
      else
         actions.each do |action|
            if action.action.to_s =~ /ADDMEMBER/
              unless logged_in == true
                logged_in = true
                login_time = action.timestamp
              end
           elsif action.action.to_s =~ /REMOVEMEMBER/
             unless logged_in == false
               tmp_time = action.timestamp - login_time
               total_time += (tmp_time/60.0)
              logged_in = false
             end
          end
         end
       end
     else
        if actions.first.action.to_s =~ /ADDMEMBER/ # If there is only _one_ action and it's an ADDMEMBER.  We know the agent never logged off the prior night.  Calculate based on queue shift defined in LWTN's settings.
          login_time = actions.first.timestamp.to_f
          if Time.today == Time.parse(Time.at(actions.first.timestamp).strftime("%m/%d %Y"))
            total_time = ((Time.now.to_f - login_time.to_f)/60.0).to_f
          else
            total_time = ((Time.parse(Time.at(actions.first.timestamp).strftime("%m/%d %Y 23:59:59")).to_f - login_time.to_f)/60.0).to_f
          end
       else
          login_time = Time.parse(Time.at(actions.first.timestamp).strftime("%m/%d %Y")).to_f
         total_time = (actions.first.timestamp.to_f - login_time.to_f) / 60.0
       end
     end
    end
    total_time += ((Time.parse(Time.at(actions.first.timestamp).strftime("%m/%d %Y 23:59:59")).to_f - login_time.to_f)/60.0).to_f if logged_in
    return "%0.2f" % (total_time).to_f
  end

end
