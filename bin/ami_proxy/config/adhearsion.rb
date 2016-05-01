Adhearsion.config do |config|
  
  # Supported levels (in increasing severity) -- :debug < :info < :warn < :error < :fatal
  config.production do |prod|
    prod.platform.logging.level = :warn
  end
  
  # In development, give more output
  config.development do |dev|
    dev.platform.logging.level = :debug
  end

  ##
  # Use with Asterisk
  #
  config.punchblock.platform = :asterisk # Use Asterisk
  config.punchblock.username = "username" # Your AMI username
  config.punchblock.password = "secret" # Your AMI password
  config.punchblock.host = "127.0.0.1" # Your AMI host
  config.punchblock.port = 5038 # Your AMI port

  ##
  # DRB plugin
  #
  config.adhearsion_drb.host = "localhost"
  config.adhearsion_drb.port = 9050
  config.adhearsion_drb.acl.allow = ["127.0.0.1"] # list of allowed IPs (optional)
  config.adhearsion_drb.acl.deny = [] # list of denied IPs (optional)
  config.adhearsion_drb.shared_object = AmiRemote.new
end
