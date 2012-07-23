# report_controller.rb - Copyright 2008 Jayson Vaughn 
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

require 'fastercsv'

class ReportController < ApplicationController

  def queue_report
    get_date_range
    @queues = Queu.find(:all)
  end

  def monthly_queue_report
    get_month_range
    @queues = Queu.find(:all)
  end

  def full_report
    get_date_range
    @agents = Agent.find(:all)
    @queues = Queu.find(:all)
  end

  def agent_report
    get_date_range
    @agent = Agent.find(params[:agent][:id].to_i)
  end

  def group_report
    get_date_range
    if params[:group]
      unless params[:group][:name] =~ /all/i
        @groupname = params[:group][:name]
        @group = Group.find_by_name(params[:group][:name])
        @agents = @group.agents
      else
        @groupname = "All"
        @agents = Agent.find(:all) 
      end
    end
  end

  def export_queue_report
    get_exported_date_range
    @queues = Queu.find(:all)
    stream_csv do |csv|
      csv << ["Queue Report", "#{@bmonth}/#{@bday} #{@byear}", "#{@emonth}/#{@eday} #{@eyear}"]  
      csv << [""]
      csv << Queu.export_queue_header
      @queues.each do |q|
        csv << q.export_queue_report(@bmonth, @bday, @byear, @emonth, @eday, @eyear)
      end
    end
  end

  def export_agent_report
    get_exported_date_range
    @agent = Agent.find(params[:agent_id])
    stream_csv do |csv|
      csv << ["Agent Report", "#{@agent.channel}", "#{@agent.first} #{@agent.last}", "#{@bmonth}/#{@bday} #{@byear}", "#{@emonth}/#{@eday} #{@eyear}"]  
      csv << [""]
      csv << Agent.export_agent_header
      csv << @agent.export_agent_report(@bmonth, @bday, @byear, @emonth, @eday, @eyear)
      end
  end

  def export_group_report
    get_exported_date_range
    if params[:groupname]
      unless params[:groupname] =~ /all/i
        @groupname = params[:groupname]
        @group = Group.find_by_name(params[:groupname])
        @agents = @group.agents
      else
        @groupname = "All"
        @agents = Agent.find(:all)
      end
    end
    stream_csv do |csv|
      csv << ["Agent Group Report", "#{@groupname}", "#{@bmonth}/#{@bday} #{@byear}", "#{@emonth}/#{@eday} #{@eyear}"]
      csv << [""]
      csv << Agent.export_agent_header
      @agents.each do |agent|
        csv << agent.export_agent_report(@bmonth, @bday, @byear, @emonth, @eday, @eyear)
        end
      end
  end

  def export_full_report
    get_exported_date_range
    @agents = Agent.find(:all)
    @queues = Queu.find(:all)
    stream_csv do |csv|
      csv << ["Full Summary Report", "#{@bmonth}/#{@bday} #{@byear}", "#{@emonth}/#{@eday} #{@eyear}"]  
      csv << [""]
      csv << ["Agents", "#{@bmonth}/#{@bday} #{@byear}", "#{@emonth}/#{@eday} #{@eyear}"]
      csv << Agent.export_agent_header
      @agents.each do |agent|
        csv << agent.export_agent_report(@bmonth, @bday, @byear, @emonth, @eday, @eyear)
         end
      csv << [""]
      csv << ["Queues", "#{@bmonth}/#{@bday} #{@byear}", "#{@emonth}/#{@eday} #{@eyear}"]
      csv << Queu.export_queue_header
      @queues.each do |q|
        csv << q.export_queue_report(@bmonth, @bday, @byear, @emonth, @eday, @eyear)
        end
      end
  end

  private
  class Writer < Object
    # FasterCSV wants an object with a << method
    def initialize(writer)
      @writer = writer
    end

    def <<(data)
      @writer.write(data)
    end
  end

  def stream_csv
    filename = params[:action] + ".csv"    
    #this is required if you want this to work with IE   
    if request.env['HTTP_USER_AGENT'] =~ /msie/i
      headers['Pragma'] = 'public'
      headers["Content-type"] = "text/plain"
      headers['Cache-Control'] = 'no-cache, must-revalidate, post-check=0, pre-check=0'
      headers['Content-Disposition'] = "attachment; filename=\"#{filename}\""
      headers['Expires'] = "0"
    else
      headers["Content-Type"] ||= 'text/csv'
      headers["Content-Disposition"] = "attachment; filename=\"#{filename}\"" 
    end
    render :text => Proc.new { |response, output|
      csv = FasterCSV.new(ReportController::Writer.new(output), :row_sep => "\r\n")
      yield csv
    }
  end

  def get_date_range
    @bmonth = params[:date]["start(2i)"]
    @bday = params[:date]["start(3i)"]
    @byear = params[:date]["start(1i)"]
    @emonth = params[:date]["end(2i)"]
    @eday = params[:date]["end(3i)"]
    @eyear = params[:date]["end(1i)"]
  end

  def get_exported_date_range
    @bmonth = params[:bmonth]
    @bday = params[:bday]
    @byear = params[:byear]
    @emonth = params[:emonth]
    @eday = params[:eday]
    @eyear = params[:eyear]
  end
  
  def get_month_range
    year = Time.now.year
    month = params[:date]['month'].to_i
    days = Time.days_in_month(month, year)
    @days = []

    (1..days).each do |i|
      @days.push({
        :month => month,
        :year => year,
        :day => i,
      })
    end
  end

end
