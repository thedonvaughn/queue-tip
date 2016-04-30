# queus_controller.rb - Copyright 2008 Jayson Vaughn 
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

class QueusController < ApplicationController
  # GET /queus
  # GET /queus.xml
  def index
    @queus = Queu.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @queus }
    end
  end

  # GET /queus/1
  # GET /queus/1.xml
  def show
    @queu = Queu.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @queu }
    end
  end

  # GET /queus/new
  # GET /queus/new.xml
  def new
    @queu = Queu.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @queu }
    end
  end

  # GET /queus/1/edit
  def edit
    @queu = Queu.find(params[:id])
  end

  # POST /queus
  # POST /queus.xml
  def create
    @queu = Queu.new(params[:queu])

    respond_to do |format|
      if @queu.save
        flash[:notice] = 'Queu was successfully created.'
        format.html { redirect_to(@queu) }
        format.xml  { render :xml => @queu, :status => :created, :location => @queu }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @queu.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /queus/1
  # PUT /queus/1.xml
  def update
    @queu = Queu.find(params[:id])

    respond_to do |format|
      if @queu.update_attributes(params[:queu])
        flash[:notice] = 'Queu was successfully updated.'
        format.html { redirect_to(@queu) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @queu.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /queus/1
  # DELETE /queus/1.xml
  def destroy
    @queu = Queu.find(params[:id])
    @queu.destroy

    respond_to do |format|
      format.html { redirect_to(queus_url) }
      format.xml  { head :ok }
    end
  end
end
