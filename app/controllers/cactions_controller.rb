# cactions_controller.rb - Copyright 2008 Jayson Vaughn 
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

class CactionsController < ApplicationController
  # GET /cactions
  # GET /cactions.xml
  def index
    @cactions = Caction.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cactions }
    end
  end

  # GET /cactions/1
  # GET /cactions/1.xml
  def show
    @caction = Caction.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @caction }
    end
  end

  # GET /cactions/new
  # GET /cactions/new.xml
  def new
    @caction = Caction.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @caction }
    end
  end

  # GET /cactions/1/edit
  def edit
    @caction = Caction.find(params[:id])
  end

  # POST /cactions
  # POST /cactions.xml
  def create
    @caction = Caction.new(params[:caction])

    respond_to do |format|
      if @caction.save
        flash[:notice] = 'Caction was successfully created.'
        format.html { redirect_to(@caction) }
        format.xml  { render :xml => @caction, :status => :created, :location => @caction }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @caction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cactions/1
  # PUT /cactions/1.xml
  def update
    @caction = Caction.find(params[:id])

    respond_to do |format|
      if @caction.update_attributes(params[:caction])
        flash[:notice] = 'Caction was successfully updated.'
        format.html { redirect_to(@caction) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @caction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cactions/1
  # DELETE /cactions/1.xml
  def destroy
    @caction = Caction.find(params[:id])
    @caction.destroy

    respond_to do |format|
      format.html { redirect_to(cactions_url) }
      format.xml  { head :ok }
    end
  end
end
