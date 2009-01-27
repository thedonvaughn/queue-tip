# start_controller.rb - Copyright 2008 Jayson Vaughn 
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

class StartController < ApplicationController
  before_filter :load_config
  rescue_from SocketError, :with => :redirect_index2

  def index
    if params
      if params[:logoffall] == "true"
        Queu.log_off_all_agents
        flash[:notice] = 'Logged off all agents!'
      end
    end
  end

  private

  def load_config
    @config = QueueTip.config
  end

  def redirect_index2
    flash[:notice] = "Can not resolve hostname! Please check your settings"
    redirect_to(:controller => 'start', :action => "index")
  end

end
