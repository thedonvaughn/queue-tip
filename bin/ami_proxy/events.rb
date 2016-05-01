# vim: sts=2 sw=2 ts=2 et
##
# In this file you can define callbacks for different aspects of the framework. Below is an example:
##
#
# events.asterisk.before_call.each do |call|
#   # This simply logs the extension for all calls going through this Adhearsion app.
#   extension = call.variables[:extension]
#   logger.info "Got a new call with extension #{extension}"
# end
#
##
# Asterisk Manager Interface example:
#
# events.asterisk.manager_interface.each do |event|
#   logger.info event.inspect
# end
#
# This assumes you gave :events => true to the config.asterisk.enable_ami method in config/startup.rb
#
##
# Here is a list of the events included by default:
#
# - events.asterisk.manager_interface
# - events.after_initialized
# - events.shutdown
# - events.asterisk.before_call
# - events.asterisk.failed_call
# - events.asterisk.hungup_call
#
#
# Note: events are mostly for components to register and expose to you.
##


## TODO: This doesn't work anymore
require 'date'

events.asterisk.manager_interface.each do |event|
  next unless event['Queue'] or event['UserEvent']
  
  event['Time'] = DateTime.now
  push_event(event)
end
	
