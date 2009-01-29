# live_view_controller.rb - Copyright 2008 Jayson Vaughn 
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

class LiveViewController < ApplicationController

  rescue_from Errno::ECONNREFUSED, :with => :refused_error
  rescue_from SocketError, :with => :resolve_error
  rescue_from Errno::ETIMEDOUT, :with => :timeout_error

  
  def index
    @ami_conn = AMI.new
    @ami_conn.login
    @queues = @ami_conn.queue_status
    @ami_conn.logoff
  end

  def update_queues 
    @ami_conn = AMI.new
    @ami_conn.login
    @queues = @ami_conn.queue_status
    @ami_conn.logoff
    render(:partial => 'queue_stats.html.erb')
  end

  def logoff
    @ami_conn = AMI.new
    @ami_conn.login
    @ami_conn.queueremove(:queue => params[:queue].to_s, :interface => params[:agent].to_s)
    @ami_conn.logoff
    flash[:notice] = "Logged off #{params[:agent].to_s} from Queue: #{params[:queue].to_s}"
    redirect_to(:controller => 'live_view', :action => 'index')
  end

  def pause_agent
    @ami_conn = AMI.new
    @ami_conn.login
    @ami_conn.agent_pause(params[:agent].to_s)
    @ami_conn.logoff
    flash[:notice] = "Paused Agent: #{params[:agent].to_s}"
    redirect_to(:controller => 'live_view', :action => 'index')
  end

  def unpause_agent
    @ami_conn = AMI.new
    @ami_conn.login
    @ami_conn.agent_unpause(params[:agent].to_s)
    @ami_conn.logoff
    flash[:notice] = "Un-Paused Agent: #{params[:agent].to_s}"
    redirect_to(:controller => 'live_view', :action => 'index')
  end

  private

  def refused_error
    flash[:notice] = "Connection refused! Please check your settings!"
    redirect_to(:controller => 'start', :action => "index")
  end

  def resolve_error
    flash[:notice] = "Can not resolve the hostname.  Please check your settings!"
    redirect_to(:controller => 'start', :action => "index")
  end

  def timeout_error
    flash[:notice] = "Can not resolve the hostname.  Please check your settings!"
    redirect_to(:controller => 'start', :action => "index")
  end

end
