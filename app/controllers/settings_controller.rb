# settings_controller.rb - Copyright 2008 Jayson Vaughn 
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

class SettingsController < ApplicationController
  before_filter :load_config

  # GET /settings
  # GET /settings.xml
  def index
    if params[:queuetastic]
      config = {}
      config['queuetastic'] = params[:queuetastic]
      File.open(Queuetastic.config_file, 'w') { |f| f.puts config.to_yaml }
    end

    respond_to do |format|
      if params[:queuetastic]
        load_config
        flash[:notice] = 'Settings were successfully updated.'
        format.html # index.html.erb
        format.xml  { render :xml => @config }
      else
        format.html # index.html.erb
        format.xml  { render :xml => @config }
      end
    end
  end

  def edit_settings

    respond_to do |format|
      format.html # edit_settings.html.erb
      format.xml  { render :xml => @config }
    end
  end

  private

  def load_config
    @config = Queuetastic.config
  end

end
