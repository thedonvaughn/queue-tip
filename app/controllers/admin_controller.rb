# admin_controller.rb - Copyright 2008 Jayson Vaughn 
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

class AdminController < ApplicationController
  rescue_from Errno::ENOENT, :with => :redirect_index
  before_filter :load_config

  # GET /admin
  # GET /admin.xml
  def index
    respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @config }
      end
  end

  def edit_settings
    respond_to do |format|
      format.html # edit_settings.html.erb
      format.xml  { render :xml => @config }
    end
  end

  def show_settings
    respond_to do |format|
      format.html
      format.xml {render :xml => @config }
    end
  end

  def update_settings
    if params[:queuetip]
      config = {}
      config['queuetip'] = params[:queuetip]
      File.open(QueueTip.config_file, 'w') { |f| f.puts config.to_yaml }
      flash[:notice] = "Settings were successfully updated."
    else
      flash[:notice] = "Settings were NOT updated succesfully."
    end
    redirect_to(:controller => 'admin', :action => 'show_settings')
  end

  def load_queue_log
    @queue_log = QueueLog.new
    conn = QtAmi.new
    logger = QueueLog.new
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
    flash[:notice] = "Queue Log loaded #{num_records} records from #{num_files} files"
    redirect_to(:controller => 'admin', :action => 'index')
  end

  def logoff_all_agents
    Queu.log_off_all_agents
    flash[:notice] = 'Logged off all agents!'
    redirect_to(:controller => 'admin', :action => 'index')
  end

  def reset_queues
    ami_conn = QtAmi.new
    ami_conn.reset_queue
    flash[:notice] = "Succesfully restarted Asterisk queue stats"
    redirect_to(:controller => 'admin', :action => 'index')
  end

  private

  def load_config
    @config = QueueTip.config
  end

  def redirect_index
    flash[:notice] = "Can not open log file! Please check your settings"
    redirect_to(:controller => 'admin', :action => "index")
  end

end
