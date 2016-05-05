# Configure your asterisk servers here.

AmiProxy::Asterisk.servers = [
  {
    :host => 'localhost',
    :port => 5038,
    :username => 'username',
    :password => 'secret',
    # If you want to override the default, put it here
    # :timeout => 10
  }
]
