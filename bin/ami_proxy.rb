#!/usr/bin/env ruby

# This starts the proxy server which connects to each of your Asterisk
# servers, reads queue information and passes on commands to these
# servers.  Asterisk servers can be configured in config/asterisk.rb
# and the drb server can be configured in config/drb.rb

require 'celluloid'
require 'drb'
require 'drb/acl'
require 'logger'
require 'ruby_ami'

AMI_DIR = File.join(File.dirname(__FILE__), 'ami_proxy')
load File.join(AMI_DIR,'lib/drb_server.rb')
load File.join(AMI_DIR,'lib/responder.rb')
load File.join(AMI_DIR,'lib/asterisk.rb')
load File.join(AMI_DIR,'lib/event_handler.rb')

# Create logger so user can override it in config
module AmiProxy
  class Logging
    class << self
      attr_accessor :log_level, :logger
      log_level = Logger::INFO
    end
  end
end

Dir.glob(File.join(AMI_DIR, 'config/*.rb')) {|f| load(f) }

# Set up logger after configuration is loaded, so responders and
# event handlers have access to it immediately.
unless AmiProxy::Logging.logger # Maybe user overrode it?
  log = Logger.new(STDOUT)
  log.level = AmiProxy::Logging.log_level
  log.formatter = proc do |severity, datetime, progname, msg|
    "#{severity}: #{msg}\n"
  end
  AmiProxy::Logging.logger = log
end

# Drop new DRb responders in this dir:
Dir.glob(File.join(AMI_DIR, 'responders/*.rb')) {|f| load(f) }
# Drop new AMI event handlers in this dir:
Dir.glob(File.join(AMI_DIR, 'event_handlers/*.rb')) {|f| load(f) }

asterisk = AmiProxy::Asterisk.new()
asterisk.connect!
# Let the DRb server block; if it exits, we're done
AmiProxy::DRbServer.run!
