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
  before_filter :establish_connection

  rescue_from Errno::ECONNREFUSED, :with => :refused_error
  rescue_from SocketError, :with => :resolve_error
  rescue_from Errno::ETIMEDOUT, :with => :timeout_error
  rescue_from DRb::DRbConnError, :with => :drb_error

  
  def index
    @queues = @ami_conn.queue_status
  end

  def update_queues 
    @queues = @ami_conn.queue_status
    render(:partial => 'queue_stats.html.erb')
  end

  def logoff
    @ami_conn.agent_logoff(:queue => params[:queue].to_s, :interface => params[:agent].to_s)
    flash[:notice] = "Logged off #{params[:agent].to_s} from Queue: #{params[:queue].to_s}"
    redirect_to(:controller => 'live_view', :action => 'index')
  end

  def pause_agent
    @ami_conn.agent_pause(params[:agent].to_s)
    flash[:notice] = "Paused Agent: #{params[:agent].to_s}"
    redirect_to(:controller => 'live_view', :action => 'index')
  end

  def unpause_agent
    @ami_conn.agent_unpause(params[:agent].to_s)
    flash[:notice] = "Un-Paused Agent: #{params[:agent].to_s}"
    redirect_to(:controller => 'live_view', :action => 'index')
  end

  private

  def establish_connection
    @ami_conn ||= QtAmi.new
  end

  def refused_error
    flash[:notice] = "Connection refused! Please check your settings!"
    redirect_to(:controller => 'start', :action => "index")
  end

  def drb_error
    flash[:notice] = "Can't talk to the asterisk proxy! Please issue 'ahn start bin/ami_proxy'"
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
