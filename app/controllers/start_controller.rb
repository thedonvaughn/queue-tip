# start_controller.rb - Copyright 2008 Jayson Vaughn 
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

class StartController < ApplicationController
  before_filter :load_config
  rescue_from Errno::ENOENT, :with => :redirect_index
  rescue_from SocketError, :with => :redirect_index2

  def index
    if params
      if params[:logoffall] == "true"
        Queu.log_off_all_agents
        flash[:notice] = 'Logged off all agents!'
      end
      if params[:update] and params[:update] == "true"
        @queue_log = QueueLog.new
        totals = @queue_log.process_log_file
        flash[:notice] = "#{@config['queuetastic']['queue_log']} was processed and #{totals} total new records were inserted."
      end
    end
  end

  private

  def load_config
    @config = Queuetastic.config
  end

  def redirect_index
    flash[:notice] = "Can not open log file! Please check your settings"
    redirect_to(:controller => 'start', :action => "index")
  end

  def redirect_index2
    flash[:notice] = "Can not resolve hostname! Please check your settings"
    redirect_to(:controller => 'start', :action => "index")
  end

end
