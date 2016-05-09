# Configure your asterisk servers here.

AmiProxy::Asterisk.servers = [
  {
    :host => 'localhost',
    :port => 5038,
    :username => 'username',
    :password => 'secret',
    # If you want to override the default, put it here
    # :timeout => 10
    # Missing files are ignored
    :queue_log_files => [
      '/var/log/asterisk/queue_log',
      '/var/log/asterisk/queue_log.1.gz',
    ]
    # HTTP also works out of the box (through the OpenURI hook):
    # :queue_log_files => ['http://pbx1.local/queue_log']
    # If the net-scp gem is installed, this works too:
    # :queue_log_files => [
    #  'scp://pbx1.local/var/log/asterisk/queue_log',
    #  'scp://pbx1.local/var/log/asterisk/queue_log.1.gz',
    # ]
    # It is better to set up an SSH key, but you can set a password or
    # alternate port like this (be careful, password will be logged
    # if file can not be fetched!):
    # :queue_log_open_args => { :ssh => { :port => 2222, :password => 'foo' } }
  }
]
