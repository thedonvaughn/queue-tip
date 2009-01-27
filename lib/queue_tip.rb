# queue-tip.rb - Copyright 2009 Jayson Vaughn 
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

require 'yaml'

class QueueTip

  def self.config 
    @config_file = File.join(RAILS_ROOT, "config", "queue_tip.yml")
    begin
      settings = YAML.load_file(@config_file)
    rescue
      settings = {}
    end
  end

  def self.config_file
    @config_file = File.join(RAILS_ROOT, "config", "queue_tip.yml")
  end

end

