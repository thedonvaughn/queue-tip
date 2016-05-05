module QueueStatus
  # Like attributes_hash but without snake_case and to_symbol
  def get_attributes_hash(attributes)
    attributes.inject({}) do |hash, attribute|
      hash[attribute.name] = attribute.value
      hash
    end
  end

  def queue_status
    #if Adhearsion::Asterisk.manager_interface
    prag_hash = {}
    Adhearsion::Asterisk.execute_ami_action('QueueStatus') do |x|
      h = get_attributes_hash(x.attributes)
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
