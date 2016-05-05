AmiProxy::DRbServer.uri = 'druby://localhost:9050'
# The acl defaults to deny, so you'll need to whitelist trusted hosts:
AmiProxy::DRbServer.acl = %w{allow localhost}
