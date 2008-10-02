#!/usr/bin/env ruby
# reset_queue.rb - Copyright 2008 Jayson Vaughn 
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

require "rubygems"
RAILS_ENV = "development"
require "config/boot"
require "config/environment"
require RAILS_ROOT + "/lib/ami"

begin
  conn = AMI.new
  logger = QueueLog.new(:queue_log => '/var/log/asterisk/queue_log')
  puts "Logged into #{conn.server} as #{conn.username}" if conn.login 
  puts "Logged off all agents" if conn.logoffallagents
  sleep 2
  puts "Reset queue stats" if conn.reset_queue
  puts "Logged off #{conn.server}" if conn.logoff
  puts "Loading Queue Log now.......(may take a while)"
  num = logger.process_log_file
  puts "Queue Log loaded #{num} records"
  puts "Logged into #{conn.server} as #{conn.username}" if conn.login 
  puts "Rotated log file" if conn.rotate_log
  puts "Logged off #{conn.server}" if conn.logoff
rescue => e 
  puts "Error: #{e}\n" + e.backtrace.join("\n\t")
  puts e.inspect
  raise
end


