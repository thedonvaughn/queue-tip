# ami.rb - Copyright 2008 Jayson Vaughn 
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

require 'socket'

class AMI
  attr_accessor :server, :port, :username, :secret, :ami_socket, :events

  def initialize(args = {})
    @config = QueueTip.config
    @server = @config['queuetip']['ast_server'] || "127.0.0.1"
    @port = @config['queuetip']['ast_port'] || "5038" 
    @username = @config['queuetip']['username'] || "username" 
    @secret = @config['queuetip']['secret'] || "secret"
    @events = args[:events] || "off"
  end

  public
  
  def status(args = {})
    args[:action] = "status"
    ami_packet(args)
  end

  def queueremove(args = {})
    args[:action] = "QueueRemove"
    ami_packet(args)
  end

  def queue_pause(args = {})
    args[:action] = "QueuePause"
    ami_packet(args)
  end

  def agent_pause(interface)
    args = {:interface => interface, :paused => true}
    queue_pause(args)
  end

  def agent_unpause(interface)
    args = {:interface => interface, :paused => false}
    queue_pause(args)
  end
  
  def reset_queue
    command(:command => "module reload app_queue")
  end

  def rotate_log
     command(:command => "logger rotate")
  end
	
  def logoffallagents
    qstats = queue_status
    qstats.each do |key, value|
      qstats[key]["members"].each do |agent, elements|
        queueremove(:queue => key, :interface => agent)
      end
    end
  end

  def queue_status(args = {})
    args[:action] = "QueueStatus"
    event_buff = ""
    qstats = {}
    unless @ami_socket.nil?
      #puts "Sent AMI request: Queues"
      @ami_socket.send("action: #{args[:action]}\r\n", 0)
      @ami_socket.send("\r\n", 0)
     while line = get_line # Try to find a response, not an event
       break if line =~ /QueueStatusComplete/
       if line =~ /QueueParams/           # Read QueueParams events
         queue = get_line.gsub(/queue: /i, "").chomp
         max = get_line.gsub(/max: /i, "").chomp
         calls = get_line.gsub(/calls: /i, "").chomp
         holdtime = get_line.gsub(/holdtime: /i, "").chomp
         completed = get_line.gsub(/completed: /i, "").chomp
         abandoned = get_line.gsub(/abandoned: /i, "").chomp
         service_level = get_line.gsub(/servicelevel: /i, "").chomp
         service_level_perf = get_line.gsub(/servicelevelperf: /i, "").chomp
         weight = get_line.gsub(/weight: /i, "").chomp
         qstats[queue] = { 'members' => {}, 'callers' => {}, 'name' => queue, 'max' => max, 'calls' => calls, 'holdtime' => holdtime, 'completed' => completed, 'abandoned' => abandoned, 'service_level' => service_level, 'service_level_perf' => service_level_perf, 'weight' => weight } unless qstats[queue]
       end
       if line =~ /QueueMember/            # Read QueueMember events
         queue_name = get_line.gsub(/queue: /i, "").chomp
         agent = get_line.gsub(/name: /i, "").chomp
         location = get_line.gsub(/location: /i, "").chomp
         membership = get_line.gsub(/membership: /i, "").chomp
         penalty = get_line.gsub(/penalty: /i, "").chomp
         calls_taken = get_line.gsub(/callstaken: /i, "").chomp
         lastcall = get_line.gsub(/lastcall: /i, "").chomp
         status = get_line.gsub(/status: /i, "").chomp
         paused = get_line.gsub(/paused: /i, "").chomp
         qstats[queue_name] = { 'members' => {}, 'callers' => {} } unless qstats[queue_name]
         qstats[queue_name]['members'].merge!(agent => { "queue" => queue_name, "agent" => agent, "location" => location, "membership" => membership, "penalty" => penalty, "calls_taken" => calls_taken, "lastcall" => lastcall, "status" => status, "paused" => paused})
       end
       if line =~ /QueueEntry/            # Read Caller Information
         queue_name = get_line.gsub(/queue: /i, "").chomp
         position = get_line.gsub(/position: /i, "").chomp
         channel = get_line.gsub(/channel: /i, "").chomp
         callerid = get_line.gsub(/callerid: /i, "").chomp
         calleridname = get_line.gsub(/calleridname: /i, "").chomp
         wait = get_line.gsub(/wait: /i, "").chomp
         qstats[queue_name] = { 'members' => {}, 'callers' => {} } unless qstats[queue_name]
         qstats[queue_name]['callers'].merge!(position => { "queue" => queue_name, "position" => position, "channel" => channel, "phone_no" => callerid, "name" => calleridname, "wait" => wait})
       end
     end
    end
   qstats 
  end

  def login
    unless @login == true
        @ami_socket = TCPsocket.open(self.server, self.port.to_i)
        login_action = {
          :action => "login",
          :username => self.username,
          :secret => self.secret,
          :events => @events }
        result = ami_packet(login_action)
        @login = (result["response"] == "success" ? true : false)
    end
    @login
  end

  def logoff
    unless @login == false
	    result = ami_packet({:action => "logoff"})
    	@ami_socket.close
    	@login = (result["response"] == "success" ? true : false)
    end
    (@login == false ? true : false)	
  end

  private

  def ami_packet(action = {})
    #action_id = Time.now.to_f
    event_buff = ""
    unless @ami_socket.nil?
      #puts "Sent AMI request: #{action.inspect}"
      action.each do |key, value|
      @ami_socket.send("#{key}: #{value}\r\n", 0)
     end
      @ami_socket.send("\r\n", 0)
     while line = get_line # Grab input, search for a response instead of an event.
         if line.downcase =~ /response/
          event_buff <<  line.downcase
           2.times do 
     	 	 line = get_line
     		 event_buff << line.downcase
        end
     	  break
     	 end
    	 end
    end
    response = YAML.load(event_buff.gsub("interface:", "interface"))
  end

  def command(args = {})
    args[:action] = "Command"
    unless @ami_socket.nil?
      #puts "Sent AMI Command request: #{args[:command]}"
      @ami_socket.send("action: #{args[:action]}\r\n", 0)
      @ami_socket.send("command: #{args[:command]}\r\n", 0)
      @ami_socket.send("\r\n", 0)
      while line = get_line
        break if line =~ /END COMMAND/
        puts line
      end
    end
  end

  def get_line
    unless @ami_socket.nil?
      @ami_socket.gets
      $_ 
    else
      raise IOError
    end
  end

end
