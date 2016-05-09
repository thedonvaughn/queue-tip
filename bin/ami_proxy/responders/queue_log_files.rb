class QueueLogFiles < AmiProxy::Responder
  on :queue_log_files do
    AmiProxy::Asterisk.servers.inject([]) do |res, sv|
      (sv[:queue_log_files] || []).inject(res) do |res, file_name|
        res + [[file_name, sv[:queue_log_open_args]]]
      end
    end
  end
end
