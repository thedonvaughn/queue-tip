# queue.rake - Copyright 2008 Jayson Vaughn 
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

require "qt_ami"
require "queue_log"

namespace :queue do
  desc "Reset the queue stats and reload from a log-file"
  task :reset => [:environment] do
    begin
      conn = QtAmi.new
      logger = QueueLog.new
      # TODO: It'd be better if we did this per server, logging
      # everyone off, resetting queue stats, and *then* loading the
      # log file for that server into our database.
      puts "Logged off all agents" if conn.log_off_all_agents
      sleep 2
      puts "Reset queue stats" if conn.reset_queue
      puts "Loading Queue Log now.......(may take a while)"

      num_records = 0
      num_files = 0
      conn.queue_log_files.each do |file, open_args|
        begin
          num_records += logger.process_file(file, open_args)
          num_files += 1 # After, so it only is incremented on success
        rescue Errno::ENOENT
          puts "Could not load log file #{file} #{open_args}"
        end
      end
      puts "Queue Log loaded #{num_records} records from #{num_files} files"
    rescue => e 
      puts "Error: #{e}\n" + e.backtrace.join("\n\t")
      puts e.inspect
      raise
    end
  end
end
