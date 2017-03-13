class QueueStatus < AmiProxy::Responder
  on :queue_status do
    prag_hash = {}
    AmiProxy::Asterisk.send_to_all_servers('QueueStatus').each do |s|
      s.events.each do |e|
        h = e.headers
        prag_hash[h['Queue']] = { :members => {}, :callers => {} } .merge(h) if e.name =~ /QueueParams/i
        prag_hash[h['Queue']][:members].merge!(h['Name'] => {}.merge(h)) if e.name =~ /QueueMember/i
        prag_hash[h['Queue']][:callers].merge!(h['Position'] => {}.merge(h)) if e.name =~ /QueueEntry/i
      end
    end
    return prag_hash
  end
end
