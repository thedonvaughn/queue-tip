# aactions_controller.rb - Copyright 2008 Jayson Vaughn 
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

class AactionsController < ApplicationController
  # GET /aactions
  # GET /aactions.xml
  def index
    @aactions = Aaction.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @aactions }
    end
  end

  # GET /aactions/1
  # GET /aactions/1.xml
  def show
    @aaction = Aaction.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @aaction }
    end
  end

  # GET /aactions/new
  # GET /aactions/new.xml
  def new
    @aaction = Aaction.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @aaction }
    end
  end

  # GET /aactions/1/edit
  def edit
    @aaction = Aaction.find(params[:id])
  end

  # POST /aactions
  # POST /aactions.xml
  def create
    @aaction = Aaction.new(params[:aaction])

    respond_to do |format|
      if @aaction.save
        flash[:notice] = 'Aaction was successfully created.'
        format.html { redirect_to(@aaction) }
        format.xml  { render :xml => @aaction, :status => :created, :location => @aaction }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @aaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /aactions/1
  # PUT /aactions/1.xml
  def update
    @aaction = Aaction.find(params[:id])

    respond_to do |format|
      if @aaction.update_attributes(params[:aaction])
        flash[:notice] = 'Aaction was successfully updated.'
        format.html { redirect_to(@aaction) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @aaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /aactions/1
  # DELETE /aactions/1.xml
  def destroy
    @aaction = Aaction.find(params[:id])
    @aaction.destroy

    respond_to do |format|
      format.html { redirect_to(aactions_url) }
      format.xml  { head :ok }
    end
  end
end
