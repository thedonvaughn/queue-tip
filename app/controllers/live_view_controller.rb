# live_view_controller.rb - Copyright 2008 Jayson Vaughn 
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

class LiveViewController < ApplicationController

  rescue_from Errno::ECONNREFUSED, :with => :redirect_index
  rescue_from SocketError, :with => :redirect_index2
  
  def index
    @ami_conn = AMI.new
    @ami_conn.login
    @queues = @ami_conn.queue_status
    if params[:logoff] == "true"
      @ami_conn.queueremove(:queue => params[:queue].to_s, :interface => params[:agent].to_s)
    end
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
  end

  def redirect_index
    flash[:notice] = "Connection refused! Please check your settings!"
    redirect_to(:controller => 'start', :action => "index")
  end

  def redirect_index2
    flash[:notice] = "Can not resolve the hostname.  Please check your settings!"
    redirect_to(:controller => 'start', :action => "index")
  end

end
