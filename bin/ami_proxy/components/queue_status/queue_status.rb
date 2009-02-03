# See http://docs.adhearsion.com for more information on how to write components or
# look at the examples in newly-created projects.
methods_for :rpc do
    
  def queue_status
    if VoIP::Asterisk.manager_interface
      result = VoIP::Asterisk.manager_interface.send_action 'queuestatus'
    else
      ahn_log.ami_remote.error "AMI has not been enabled in startup.rb!"
    end
    prag_hash = {}
    result.each do |x|
      prag_hash[x['Queue']] = { :members => {}, :callers => {} } .merge(x.headers) if x.name =~ /queueparams/i
      prag_hash[x['Queue']][:members].merge!(x.headers['Name'] => {}.merge(x.headers)) if x.name =~ /queuemember/i
      prag_hash[x['Queue']][:callers].merge!(x.headers['Position'] => {}.merge(x.headers)) if x.name =~ /queueentry/i
    end
    return prag_hash
  end

end


