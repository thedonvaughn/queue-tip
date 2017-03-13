class AmiRemote < AmiProxy::Responder
  # Simply create proxy methods for the high-level AMI methods
  on :send_action do |*args|
    AmiProxy::Asterisk.send_to_all_servers(*args)
  end

  [:introduce, :originate, :call_into_context, :call_and_exec].each do |method_name|
    on(method_name) do |*args|
      AmiProxy::Asterisk.send_to_all_servers(method_name, *args)
    end
  end
end
