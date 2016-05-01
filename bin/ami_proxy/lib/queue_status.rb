module QueueStatus
  def queue_status
    #if Adhearsion::Asterisk.manager_interface
    prag_hash = {}
    Adhearsion::Asterisk.execute_ami_action('QueueStatus') do |x|
      h = x.headers
      prag_hash[h['Queue']] = { :members => {}, :callers => {} } .merge(h) if x.name =~ /QueueParams/i
      prag_hash[h['Queue']][:members].merge!(h['Name'] => {}.merge(h)) if x.name =~ /QueueMember/i
      prag_hash[h['Queue']][:callers].merge!(h['Position'] => {}.merge(h)) if x.name =~ /QueueEntry/i
    end
    return prag_hash
    #else
    #  logger.error "AMI has not been enabled!"
    #end
  end
end
